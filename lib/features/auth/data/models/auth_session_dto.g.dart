// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_session_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuthSessionDto _$AuthSessionDtoFromJson(Map<String, dynamic> json) => _AuthSessionDto(
  accessToken: json['accessToken'] as String,
  refreshToken: json['refreshToken'] as String,
  expiresAt: DateTime.parse(json['expiresAt'] as String),
  userId: json['userId'] as String,
  email: json['email'] as String,
  displayName: json['displayName'] as String? ?? '',
);

Map<String, dynamic> _$AuthSessionDtoToJson(_AuthSessionDto instance) => <String, dynamic>{
  'accessToken': instance.accessToken,
  'refreshToken': instance.refreshToken,
  'expiresAt': instance.expiresAt.toIso8601String(),
  'userId': instance.userId,
  'email': instance.email,
  'displayName': instance.displayName,
};
