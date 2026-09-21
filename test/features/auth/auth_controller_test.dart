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
  bool refreshSucceeds = true;
  Duration refreshDelay = Duration.zero;

  @override
  Future<Either<Failure, AuthSession>> login({required String email, required String password}) async {
    loginCalls++;
    if (email == 'locked@example.com') return const Left(Failure.unauthorized());
    stored = session();
    return Right(stored!);
  }

  @override
  Future<Either<Failure, AuthSession>> refresh(String refreshToken) async {
    refreshCalls++;
    await Future<void>.delayed(refreshDelay);
    if (!refreshSucceeds) {
      stored = null;
      return const Left(Failure.unauthorized());
    }
    stored = session(access: 'a${refreshCalls + 1}');
    return Right(stored!);
  }

  @override
  Future<Either<Failure, void>> logout() async {
    stored = null;
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

  test('refreshSession is a no-op without a session', () async {
    final repository = _StubRepository();
    final container = _makeContainer(repository);
    await container.read(authControllerProvider.future);

    expect(await container.read(authControllerProvider.notifier).refreshSession(), isNull);
    expect(repository.refreshCalls, 0);
  });
}
