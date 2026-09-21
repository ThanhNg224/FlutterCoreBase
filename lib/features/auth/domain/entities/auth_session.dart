import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_core_base/features/auth/domain/entities/auth_user.dart';

part 'auth_session.freezed.dart';

/// An authenticated session. `toString` is suppressed so a session can never
/// print its tokens into a log line by accident.
///
/// There is deliberately no `isExpired` helper: expiry is discovered
/// reactively from a 401, which is the only source of truth the client
/// actually has. A local clock check would be a second, weaker opinion.
@Freezed(toStringOverride: false)
abstract class AuthSession with _$AuthSession {
  const factory AuthSession({
    required String accessToken,
    required String refreshToken,
    required DateTime expiresAt,
    required AuthUser user,
  }) = _AuthSession;
}
