import 'package:flutter_core_base/features/face_otp/domain/entities/face_otp_result.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'face_otp_result_dto.freezed.dart';
part 'face_otp_result_dto.g.dart';

@freezed
abstract class FaceOtpResultDto with _$FaceOtpResultDto {
  const FaceOtpResultDto._();

  const factory FaceOtpResultDto({
    required String sessionId,
    required String status,
    required double similarityScore,
    required double livenessScore,
    required String token,
    required String verifiedAtIso,
    String? faceImageBase64,
  }) = _FaceOtpResultDto;

  factory FaceOtpResultDto.fromJson(Map<String, dynamic> json) => _$FaceOtpResultDtoFromJson(json);

  FaceOtpResult toDomain() {
    final statusEnum = switch (status.toLowerCase()) {
      'success' => VerificationStatus.success,
      'facemismatch' || 'face_mismatch' => VerificationStatus.faceMismatch,
      'spoofdetected' || 'spoof_detected' => VerificationStatus.spoofDetected,
      'timeout' => VerificationStatus.timeout,
      _ => VerificationStatus.cancelled,
    };

    return FaceOtpResult(
      sessionId: sessionId,
      status: statusEnum,
      similarityScore: similarityScore,
      livenessScore: livenessScore,
      token: token,
      verifiedAt: DateTime.tryParse(verifiedAtIso) ?? DateTime.now(),
      faceImageBase64: faceImageBase64,
    );
  }
}
