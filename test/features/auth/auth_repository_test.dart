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

  test('a failed refresh clears the persisted session', () async {
    local.stored = dto();
    when(() => remote.refresh(any())).thenThrow(const UnauthorizedException(message: 'expired'));

    final result = await repository.refresh('r');

    expect(result.isLeft(), isTrue);
    expect(local.stored, isNull, reason: 'an unrefreshable session must not survive');
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
