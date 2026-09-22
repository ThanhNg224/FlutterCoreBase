import 'package:flutter_core_base/core/errors/failure.dart';
import 'package:flutter_core_base/features/auth/domain/entities/auth_session.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class IAuthRepository {
  /// Exchanges credentials for a session and persists it.
  ///
  /// [isSessionCurrent] prevents an out-of-order login response from
  /// persisting a session after a newer generation has started.
  Future<Either<Failure, AuthSession>> login({
    required String email,
    required String password,
    bool Function()? isSessionCurrent,
  });

  /// Exchanges a refresh token for a fresh session and persists it.
  ///
  /// [isSessionCurrent] lets the caller invalidate a refresh while the remote
  /// request is in flight. A stale successful response is returned without
  /// being persisted so a newer session cannot be overwritten.
  Future<Either<Failure, AuthSession>> refresh(
    String refreshToken, {
    bool Function()? isSessionCurrent,
  });

  /// Clears the persisted session. Always succeeds locally, even if the remote
  /// revoke call fails — a user who taps "log out" must end up logged out.
  ///
  /// [isSessionCurrent] prevents an obsolete logout from clearing a newer
  /// session when its queued local mutation reaches storage.
  Future<Either<Failure, void>> logout({bool Function()? isSessionCurrent});

  /// Reads the persisted session, or `null` when there is none.
  Future<Either<Failure, AuthSession?>> restoreSession();
}
