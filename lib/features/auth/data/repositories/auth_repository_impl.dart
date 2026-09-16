import 'package:flutter_core_base/core/errors/error_handler.dart';
import 'package:flutter_core_base/core/errors/failure.dart';
import 'package:flutter_core_base/core/logging/logging.dart';
import 'package:flutter_core_base/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:flutter_core_base/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:flutter_core_base/features/auth/domain/entities/auth_session.dart';
import 'package:flutter_core_base/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repository_impl.g.dart';

const _log = AppLogger('Auth');

class AuthRepositoryImpl implements IAuthRepository {
  final IAuthRemoteDataSource remoteDataSource;
  final IAuthLocalDataSource localDataSource;

  const AuthRepositoryImpl({required this.remoteDataSource, required this.localDataSource});

  @override
  Future<Either<Failure, AuthSession>> login({required String email, required String password}) {
    return ErrorHandler.guard(() async {
      final dto = await remoteDataSource.login(email: email, password: password);
      await localDataSource.write(dto);
      _log.info('session established', data: {'user': Redacted.secret(dto.userId)});
      return dto.toDomain();
    });
  }

  @override
  Future<Either<Failure, AuthSession>> refresh(String refreshToken) async {
    final result = await ErrorHandler.guard(() async {
      final dto = await remoteDataSource.refresh(refreshToken);
      await localDataSource.write(dto);
      return dto.toDomain();
    });

    // A refresh token the server will not honour is worthless; keeping it only
    // guarantees the same failure on the next launch.
    if (result.isLeft()) {
      await localDataSource.clear();
      _log.warn('refresh failed, session cleared');
    }
    return result;
  }

  @override
  Future<Either<Failure, void>> logout() async {
    final stored = await localDataSource.read();
    if (stored != null) {
      try {
        await remoteDataSource.logout(stored.refreshToken);
      } catch (error) {
        // Best effort. The local clear below is what the user actually asked for.
        _log.warn('remote revoke failed', data: {'errorType': Redacted.type(error)});
      }
    }
    return ErrorHandler.guard(() => localDataSource.clear());
  }

  @override
  Future<Either<Failure, AuthSession?>> restoreSession() {
    return ErrorHandler.guard(() async {
      final dto = await localDataSource.read();
      return dto?.toDomain();
    });
  }
}

@Riverpod(keepAlive: true)
Future<IAuthRepository> authRepository(Ref ref) async {
  final remote = await ref.watch(authRemoteDataSourceProvider.future);
  final local = ref.watch(authLocalDataSourceProvider);
  return AuthRepositoryImpl(remoteDataSource: remote, localDataSource: local);
}
