import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_core_base/core/errors/app_exception.dart';
import 'package:flutter_core_base/core/errors/failure.dart';
import 'package:flutter_core_base/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:flutter_core_base/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:flutter_core_base/features/auth/data/models/auth_session_dto.dart';
import 'package:flutter_core_base/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRemote extends Mock implements IAuthRemoteDataSource {}

class _FakeLocal implements IAuthLocalDataSource {
  AuthSessionDto? stored;

  @override
  Future<AuthSessionDto?> read() async => stored;

  @override
  Future<void> write(AuthSessionDto session) async => stored = session;

  @override
  Future<void> clear() async => stored = null;
}

class _DelayedWriteLocal extends _FakeLocal {
  final Completer<void> writeStarted = Completer<void>();
  final Completer<void> allowWrite = Completer<void>();
  bool _delayNextWrite = true;

  @override
  Future<void> write(AuthSessionDto session) async {
    if (_delayNextWrite) {
      _delayNextWrite = false;
      writeStarted.complete();
      await allowWrite.future;
    }
    stored = session;
  }
}

AuthSessionDto dto({String access = 'a', String refresh = 'r'}) => AuthSessionDto(
  accessToken: access,
  refreshToken: refresh,
  expiresAt: DateTime.utc(2030),
  userId: 'u1',
  email: 'demo@example.com',
  displayName: 'demo',
);

void main() {
  late _MockRemote remote;
  late _FakeLocal local;
  late AuthRepositoryImpl repository;

  setUp(() {
    remote = _MockRemote();
    local = _FakeLocal();
    repository = AuthRepositoryImpl(remoteDataSource: remote, localDataSource: local);
  });

  test('a successful login persists the session', () async {
    when(
      () => remote.login(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async => dto());

    final result = await repository.login(email: 'demo@example.com', password: 'pw');

    expect(result.isRight(), isTrue);
    expect(local.stored?.accessToken, 'a');
    expect(result.getOrElse((_) => throw StateError('expected a session')).user.email, 'demo@example.com');
  });

  test('out-of-order logins only persist the current generation', () async {
    final oldLogin = Completer<AuthSessionDto>();
    final newLogin = Completer<AuthSessionDto>();
    var loginCalls = 0;
    when(
      () => remote.login(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) => loginCalls++ == 0 ? oldLogin.future : newLogin.future);
    var oldIsCurrent = true;

    final oldFuture = repository.login(email: 'old@example.com', password: 'pw', isSessionCurrent: () => oldIsCurrent);
    final newFuture = repository.login(email: 'new@example.com', password: 'pw', isSessionCurrent: () => true);

    newLogin.complete(dto(access: 'new-account', refresh: 'new-refresh'));
    await newFuture;
    oldIsCurrent = false;
    oldLogin.complete(dto(access: 'old-account', refresh: 'old-refresh'));
    await oldFuture;

    expect(local.stored?.accessToken, 'new-account');
    expect(local.stored?.refreshToken, 'new-refresh');
  });

  test('a stale logout cannot clear a newer login queued ahead of it', () async {
    final delayedLocal = _DelayedWriteLocal()..stored = dto();
    repository = AuthRepositoryImpl(remoteDataSource: remote, localDataSource: delayedLocal);
    var loginCalls = 0;
    when(
      () => remote.login(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async {
      loginCalls++;
      return loginCalls == 1 ? dto(access: 'blocker') : dto(access: 'new-account', refresh: 'new-refresh');
    });
    when(() => remote.logout(any())).thenAnswer((_) async {});

    final blocker = repository.login(email: 'old@example.com', password: 'pw');
    await delayedLocal.writeStarted.future;
    final newLogin = repository.login(
      email: 'new@example.com',
      password: 'pw',
      isSessionCurrent: () => true,
    );
    final staleLogout = repository.logout(isSessionCurrent: () => false);
    delayedLocal.allowWrite.complete();

    await blocker;
    await newLogin;
    expect((await staleLogout).isRight(), isTrue);
    expect(delayedLocal.stored?.accessToken, 'new-account');
    verifyNever(() => remote.logout(any()));
  });

  test('a rejected login maps to UnauthorizedFailure and persists nothing', () async {
    when(
      () => remote.login(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenThrow(const UnauthorizedException(message: 'nope'));

    final result = await repository.login(email: 'x@y.z', password: 'pw');

    expect(result.getLeft().toNullable(), isA<UnauthorizedFailure>());
    expect(local.stored, isNull);
  });

  test('refresh replaces the persisted session', () async {
    local.stored = dto();
    when(() => remote.refresh(any())).thenAnswer((_) async => dto(access: 'a2', refresh: 'r2'));

    final result = await repository.refresh('r');

    expect(result.isRight(), isTrue);
    expect(local.stored?.accessToken, 'a2');
  });

  test('a refresh rejected by the current-generation guard does not persist', () async {
    local.stored = dto();
    final remoteResult = Completer<AuthSessionDto>();
    when(() => remote.refresh(any())).thenAnswer((_) => remoteResult.future);
    var isCurrent = true;

    final refreshFuture = repository.refresh('r', isSessionCurrent: () => isCurrent);
    isCurrent = false;
    remoteResult.complete(dto(access: 'stale', refresh: 'stale-r'));

    final result = await refreshFuture;

    expect(result.isRight(), isTrue);
    expect(local.stored?.accessToken, 'a');
    expect(local.stored?.refreshToken, 'r');
  });

  test('a failed refresh clears the persisted session', () async {
    local.stored = dto();
    when(() => remote.refresh(any())).thenThrow(const UnauthorizedException(message: 'expired'));

    final result = await repository.refresh('r');

    expect(result.isLeft(), isTrue);
    expect(local.stored, isNull, reason: 'an unrefreshable session must not survive');
  });

  test('non-unauthorized refresh failures retain the persisted session', () async {
    final failures = <Object>[
      const NetworkException(message: 'offline'),
      DioException(
        requestOptions: RequestOptions(path: '/refresh'),
        type: DioExceptionType.connectionTimeout,
      ),
      const ServerException(message: 'server down', statusCode: 500),
      const StorageException(message: 'storage unavailable'),
      const UnexpectedException(message: 'unexpected failure'),
    ];

    for (final failure in failures) {
      local.stored = dto();
      reset(remote);
      when(() => remote.refresh(any())).thenThrow(failure);

      final result = await repository.refresh('r');

      expect(result.isLeft(), isTrue, reason: 'expected failure for $failure');
      expect(
        local.stored?.accessToken,
        'a',
        reason: 'refresh failure $failure must not clear a recoverable session',
      );
    }
  });

  test('logout local clear is ordered before a later login write', () async {
    local.stored = dto();
    final remoteRevoke = Completer<void>();
    when(() => remote.logout(any())).thenAnswer((_) => remoteRevoke.future);
    when(
      () => remote.login(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async => dto(access: 'new-account', refresh: 'new-refresh'));

    final logoutFuture = repository.logout();
    await Future<void>.delayed(Duration.zero);
    final loginResult = await repository.login(email: 'new@example.com', password: 'pw');

    expect(loginResult.isRight(), isTrue);
    expect(local.stored?.accessToken, 'new-account');

    remoteRevoke.complete();
    expect((await logoutFuture).isRight(), isTrue);
    expect(local.stored?.accessToken, 'new-account');
  });

  test('a delayed stale refresh write is followed by logout clear', () async {
    final delayedLocal = _DelayedWriteLocal()..stored = dto();
    repository = AuthRepositoryImpl(remoteDataSource: remote, localDataSource: delayedLocal);
    when(() => remote.refresh(any())).thenAnswer((_) async => dto(access: 'stale', refresh: 'stale-refresh'));
    final remoteRevoke = Completer<void>();
    when(() => remote.logout(any())).thenAnswer((_) => remoteRevoke.future);
    var isCurrent = true;

    final refreshFuture = repository.refresh('r', isSessionCurrent: () => isCurrent);
    await delayedLocal.writeStarted.future;
    isCurrent = false;
    final logoutFuture = repository.logout();
    await Future<void>.delayed(Duration.zero);
    remoteRevoke.complete();
    await Future<void>.delayed(Duration.zero);
    delayedLocal.allowWrite.complete();

    expect((await refreshFuture).isRight(), isTrue);
    expect((await logoutFuture).isRight(), isTrue);
    expect(delayedLocal.stored, isNull);
  });

  test('logout clears locally even when the remote revoke fails', () async {
    local.stored = dto();
    when(() => remote.logout(any())).thenThrow(const ServerException(message: 'down'));

    final result = await repository.logout();

    expect(result.isRight(), isTrue, reason: 'tapping log out must always log you out');
    expect(local.stored, isNull);
  });

  test('restoreSession returns null when nothing is stored', () async {
    expect((await repository.restoreSession()).getOrElse((_) => throw StateError('')), isNull);
  });

  test('restoreSession returns the stored session', () async {
    local.stored = dto();
    final session = (await repository.restoreSession()).getOrElse((_) => throw StateError(''));
    expect(session?.accessToken, 'a');
  });
}
