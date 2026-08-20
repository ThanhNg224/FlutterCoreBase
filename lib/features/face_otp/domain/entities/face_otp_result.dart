import 'package:freezed_annotation/freezed_annotation.dart';

part 'face_otp_result.freezed.dart';

enum VerificationStatus { success, faceMismatch, spoofDetected, timeout, cancelled }

@freezed
abstract class FaceOtpResult with _$FaceOtpResult {
  const factory FaceOtpResult({
    required String sessionId,
    required VerificationStatus status,
    required double similarityScore,
    required double livenessScore,
    required String token,
    required DateTime verifiedAt,
    String? faceImageBase64,
  }) = _FaceOtpResult;
}
