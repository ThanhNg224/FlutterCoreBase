// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'face_otp_result_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FaceOtpResultDto _$FaceOtpResultDtoFromJson(Map<String, dynamic> json) =>
    _FaceOtpResultDto(
      sessionId: json['sessionId'] as String,
      status: json['status'] as String,
      similarityScore: (json['similarityScore'] as num).toDouble(),
      livenessScore: (json['livenessScore'] as num).toDouble(),
      token: json['token'] as String,
      verifiedAtIso: json['verifiedAtIso'] as String,
      faceImageBase64: json['faceImageBase64'] as String?,
    );

Map<String, dynamic> _$FaceOtpResultDtoToJson(_FaceOtpResultDto instance) =>
    <String, dynamic>{
      'sessionId': instance.sessionId,
      'status': instance.status,
      'similarityScore': instance.similarityScore,
      'livenessScore': instance.livenessScore,
      'token': instance.token,
      'verifiedAtIso': instance.verifiedAtIso,
      'faceImageBase64': instance.faceImageBase64,
    };
