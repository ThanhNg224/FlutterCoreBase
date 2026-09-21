import 'dart:async';

import 'package:flutter_core_base/core/errors/failure.dart';
import 'package:flutter_core_base/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_core_base/features/auth/domain/entities/auth_session.dart';
import 'package:flutter_core_base/features/auth/domain/entities/auth_user.dart';
import 'package:flutter_core_base/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:flutter_core_base/features/auth/presentation/controllers/auth_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

AuthSession session({String access = 'a', String refresh = 'r'}) => AuthSession(
  accessToken: access,
  refreshToken: refresh,
  expiresAt: DateTime.utc(2030),
  user: const AuthUser(id: 'u1', email: 'demo@example.com', displayName: 'demo'),
);

class _StubRepository implements IAuthRepository {
  _StubRepository({this.stored});

  AuthSession? stored;
  int refreshCalls = 0;
  int loginCalls = 0;
  AuthSession loginSession = session();
  bool refreshSucceeds = true;
  Failure? refreshFailure;
  Duration refreshDelay = Duration.zero;
  final List<Completer<Either<Failure, AuthSession>>> refreshCompleters = [];
  Completer<void>? logoutRemote;
  final List<Completer<Either<Failure, AuthSession>>> loginCompleters = [];

  @override
  Future<Either<Failure, AuthSession>> login({
    required String email,
    required String password,
    bool Function()? isSessionCurrent,
  }) async {
    loginCalls++;
    if (email == 'locked@example.com') return const Left(Failure.unauthorized());
    if (loginCompleters.length >= loginCalls) {
      final result = await loginCompleters[loginCalls - 1].future;
      return result.fold(
        Left.new,
        (session) {
          if (isSessionCurrent?.call() != false) stored = session;
          return Right(session);
        },
      );
    }
    if (isSessionCurrent?.call() != false) stored = loginSession;
    return Right(stored!);
  }

  @override
  Future<Either<Failure, AuthSession>> refresh(
    String refreshToken, {
    bool Function()? isSessionCurrent,
  }) async {
    refreshCalls++;
    if (refreshCompleters.length >= refreshCalls) {
      return refreshCompleters[refreshCalls - 1].future;
    }
    await Future<void>.delayed(refreshDelay);
    if (!refreshSucceeds) {
      stored = null;
      return const Left(Failure.unauthorized());
    }
    final failure = refreshFailure;
    if (failure != null) return Left(failure);
    stored = session(access: 'a${refreshCalls + 1}');
    return Right(stored!);
  }

  @override
  Future<Either<Failure, void>> logout({bool Function()? isSessionCurrent}) async {
    stored = null;
    final pendingRemote = logoutRemote;
    if (pendingRemote != null) await pendingRemote.future;
    return const Right(null);
  }

  @override
  Future<Either<Failure, AuthSession?>> restoreSession() async => Right(stored);
}

ProviderContainer _makeContainer(_StubRepository repository) {
  final container = ProviderContainer(
    overrides: [authRepositoryProvider.overrideWith((ref) async => repository)],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  test('starts with no session when nothing is persisted', () async {
    final container = _makeContainer(_StubRepository());
    expect(await container.read(authControllerProvider.future), isNull);
  });

  test('restores a persisted session on build', () async {
    final container = _makeContainer(_StubRepository(stored: session()));
    final restored = await container.read(authControllerProvider.future);
    expect(restored?.accessToken, 'a');
  });

  test('a successful login publishes the session', () async {
    final repository = _StubRepository();
    final container = _makeContainer(repository);
    await container.read(authControllerProvider.future);

    final result = await container
        .read(authControllerProvider.notifier)
        .login(
          email: 'demo@example.com',
          password: 'pw',
        );

    expect(result.isRight(), isTrue);
    expect(container.read(authControllerProvider).value?.user.email, 'demo@example.com');
  });

  test('a failed login leaves the session null and returns the failure', () async {
    final container = _makeContainer(_StubRepository());
    await container.read(authControllerProvider.future);

    final result = await container
        .read(authControllerProvider.notifier)
        .login(
          email: 'locked@example.com',
          password: 'pw',
        );

    expect(result.getLeft().toNullable(), isA<UnauthorizedFailure>());
    expect(container.read(authControllerProvider).value, isNull);
  });

  test('logout clears the session', () async {
    final container = _makeContainer(_StubRepository(stored: session()));
    await container.read(authControllerProvider.future);

    await container.read(authControllerProvider.notifier).logout();

    expect(container.read(authControllerProvider).value, isNull);
  });

  test('concurrent refreshes share a single in-flight call', () async {
    final repository = _StubRepository(stored: session())..refreshDelay = const Duration(milliseconds: 50);
    final container = _makeContainer(repository);
    await container.read(authControllerProvider.future);
    final notifier = container.read(authControllerProvider.notifier);

    final tokens = await Future.wait([
      notifier.refreshSession(),
      notifier.refreshSession(),
      notifier.refreshSession(),
    ]);

    expect(repository.refreshCalls, 1, reason: 'three racing callers must trigger one refresh');
    expect(tokens.toSet().length, 1, reason: 'all callers get the same new token');
    expect(tokens.first, isNotNull);
  });

  test('a failed refresh clears the session and returns null', () async {
    final repository = _StubRepository(stored: session())..refreshSucceeds = false;
    final container = _makeContainer(repository);
    await container.read(authControllerProvider.future);

    final token = await container.read(authControllerProvider.notifier).refreshSession();

    expect(token, isNull);
    expect(container.read(authControllerProvider).value, isNull);
  });

  test('non-unauthorized refresh failures retain the active session', () async {
    final failures = <Failure>[
      const Failure.network(),
      const Failure.server(message: 'server down', statusCode: 500),
      const Failure.storage(message: 'storage unavailable'),
      const Failure.unexpected(message: 'unexpected failure'),
    ];

    for (final failure in failures) {
      final repository = _StubRepository(stored: session())..refreshFailure = failure;
      final container = _makeContainer(repository);
      await container.read(authControllerProvider.future);
      final notifier = container.read(authControllerProvider.notifier);

      final token = await notifier.refreshSession();

      expect(token, isNull, reason: 'refresh failure $failure must return null');
      expect(
        container.read(authControllerProvider).value?.accessToken,
        'a',
        reason: 'refresh failure $failure must retain controller state',
      );
      expect(
        repository.stored?.accessToken,
        'a',
        reason: 'refresh failure $failure must retain persisted state',
      );
    }
  });

  test('refreshSession is a no-op without a session', () async {
    final repository = _StubRepository();
    final container = _makeContainer(repository);
    await container.read(authControllerProvider.future);

    expect(await container.read(authControllerProvider.notifier).refreshSession(), isNull);
    expect(repository.refreshCalls, 0);
  });

  test('logout invalidates a refresh that is still in flight', () async {
    final repository = _StubRepository(stored: session());
    final refresh = Completer<Either<Failure, AuthSession>>();
    repository.refreshCompleters.add(refresh);
    final container = _makeContainer(repository);
    await container.read(authControllerProvider.future);
    final notifier = container.read(authControllerProvider.notifier);

    final refreshFuture = notifier.refreshSession();
    await Future<void>.delayed(Duration.zero);
    await notifier.logout();

    refresh.complete(Right(session(access: 'stale')));

    expect(await refreshFuture, isNull);
    expect(container.read(authControllerProvider).value, isNull);
  });

  test('a stale refresh cannot clear or replace a newer refresh flight', () async {
    final repository = _StubRepository(stored: session());
    final oldRefresh = Completer<Either<Failure, AuthSession>>();
    final newRefresh = Completer<Either<Failure, AuthSession>>();
    repository.refreshCompleters.addAll([oldRefresh, newRefresh]);
    final container = _makeContainer(repository);
    await container.read(authControllerProvider.future);
    final notifier = container.read(authControllerProvider.notifier);

    final oldFuture = notifier.refreshSession();
    await Future<void>.delayed(Duration.zero);
    await notifier.logout();
    await notifier.login(email: 'demo@example.com', password: 'pw');
    final newFuture = notifier.refreshSession();
    await Future<void>.delayed(Duration.zero);

    expect(repository.refreshCalls, 2);

    oldRefresh.complete(Right(session(access: 'stale')));
    expect(await oldFuture, isNull);

    newRefresh.complete(Right(session(access: 'fresh')));
    expect(await newFuture, 'fresh');
    expect(container.read(authControllerProvider).value?.accessToken, 'fresh');
  });

  test('login invalidates an old refresh from the previous account', () async {
    final repository = _StubRepository(stored: session());
    final oldRefresh = Completer<Either<Failure, AuthSession>>();
    repository.refreshCompleters.add(oldRefresh);
    repository.loginSession = session(access: 'new-account');
    final container = _makeContainer(repository);
    await container.read(authControllerProvider.future);
    final notifier = container.read(authControllerProvider.notifier);

    final oldFuture = notifier.refreshSession();
    await Future<void>.delayed(Duration.zero);
    await notifier.login(email: 'new@example.com', password: 'pw');

    oldRefresh.complete(Right(session(access: 'old-account')));

    expect(await oldFuture, isNull);
    expect(container.read(authControllerProvider).value?.accessToken, 'new-account');
  });

  test('a delayed logout cannot erase a session established by a later login', () async {
    final repository = _StubRepository(stored: session());
    final remoteLogout = Completer<void>();
    repository.logoutRemote = remoteLogout;
    repository.loginSession = session(access: 'new-account');
    final container = _makeContainer(repository);
    await container.read(authControllerProvider.future);
    final notifier = container.read(authControllerProvider.notifier);

    final logoutFuture = notifier.logout();
    await Future<void>.delayed(Duration.zero);
    await notifier.login(email: 'new@example.com', password: 'pw');

    expect(container.read(authControllerProvider).value?.accessToken, 'new-account');
    expect(repository.stored?.accessToken, 'new-account');

    remoteLogout.complete();
    await logoutFuture;

    expect(container.read(authControllerProvider).value?.accessToken, 'new-account');
    expect(repository.stored?.accessToken, 'new-account');
  });

  test('refresh during delayed logout is a no-op after logout invalidates state', () async {
    final repository = _StubRepository(stored: session());
    final remoteLogout = Completer<void>();
    repository.logoutRemote = remoteLogout;
    final container = _makeContainer(repository);
    await container.read(authControllerProvider.future);
    final notifier = container.read(authControllerProvider.notifier);

    final logoutFuture = notifier.logout();
    await Future<void>.delayed(Duration.zero);
    expect(await notifier.refreshSession(), isNull);
    expect(repository.refreshCalls, 0);
    expect(repository.stored, isNull);

    remoteLogout.complete();
    await logoutFuture;
  });

  test('out-of-order logins cannot replace the newest controller state', () async {
    final repository = _StubRepository();
    final oldLogin = Completer<Either<Failure, AuthSession>>();
    final newLogin = Completer<Either<Failure, AuthSession>>();
    repository.loginCompleters.addAll([oldLogin, newLogin]);
    final container = _makeContainer(repository);
    await container.read(authControllerProvider.future);
    final notifier = container.read(authControllerProvider.notifier);

    final oldFuture = notifier.login(email: 'old@example.com', password: 'pw');
    final newFuture = notifier.login(email: 'new@example.com', password: 'pw');

    newLogin.complete(Right(session(access: 'new-account')));
    await newFuture;
    expect(container.read(authControllerProvider).value?.accessToken, 'new-account');

    oldLogin.complete(Right(session(access: 'old-account')));
    await oldFuture;
    expect(container.read(authControllerProvider).value?.accessToken, 'new-account');
    expect(repository.stored?.accessToken, 'new-account');
  });
}
