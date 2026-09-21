import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_core_base/features/auth/domain/entities/auth_session.dart';
import 'package:flutter_core_base/features/auth/domain/entities/auth_user.dart';

part 'auth_session_dto.freezed.dart';
part 'auth_session_dto.g.dart';

@Freezed(toStringOverride: false)
abstract class AuthSessionDto with _$AuthSessionDto {
  const factory AuthSessionDto({
    required String accessToken,
    required String refreshToken,
    required DateTime expiresAt,
    required String userId,
    required String email,
    @Default('') String displayName,
  }) = _AuthSessionDto;

  const AuthSessionDto._();

  factory AuthSessionDto.fromJson(Map<String, dynamic> json) => _$AuthSessionDtoFromJson(json);

  factory AuthSessionDto.fromDomain(AuthSession session) => AuthSessionDto(
    accessToken: session.accessToken,
    refreshToken: session.refreshToken,
    expiresAt: session.expiresAt,
    userId: session.user.id,
    email: session.user.email,
    displayName: session.user.displayName,
  );

  AuthSession toDomain() => AuthSession(
    accessToken: accessToken,
    refreshToken: refreshToken,
    expiresAt: expiresAt,
    user: AuthUser(id: userId, email: email, displayName: displayName),
  );
}
