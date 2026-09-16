import 'package:flutter_core_base/core/errors/failure.dart';
import 'package:flutter_core_base/features/auth/domain/entities/auth_session.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class IAuthRepository {
  /// Exchanges credentials for a session and persists it.
  Future<Either<Failure, AuthSession>> login({required String email, required String password});

  /// Exchanges a refresh token for a fresh session and persists it.
  Future<Either<Failure, AuthSession>> refresh(String refreshToken);

  /// Clears the persisted session. Always succeeds locally, even if the remote
  /// revoke call fails — a user who taps "log out" must end up logged out.
  Future<Either<Failure, void>> logout();

  /// Reads the persisted session, or `null` when there is none.
  Future<Either<Failure, AuthSession?>> restoreSession();
}
