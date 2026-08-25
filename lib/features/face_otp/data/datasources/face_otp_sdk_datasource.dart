import 'dart:math';
import 'package:flutter_core_base/core/constants/app_constants.dart';
import 'package:flutter_core_base/core/errors/app_exception.dart';
import 'package:flutter_core_base/features/face_otp/data/models/face_otp_result_dto.dart';
import 'package:flutter_core_base/features/face_otp/domain/entities/face_otp_config.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'face_otp_sdk_datasource.g.dart';

abstract interface class IFaceOtpSdkDataSource {
  Future<FaceOtpResultDto> launchVerification(FaceOtpConfig config);
  Future<bool> cancelVerification();
}

/// Simulated / Native MethodChannel wrapper for Face OTP SDK
class FaceOtpSdkDataSource implements IFaceOtpSdkDataSource {
  @override
  Future<FaceOtpResultDto> launchVerification(FaceOtpConfig config) async {
    // Simulate real native SDK camera capture & backend verification roundtrip
    await Future<void>.delayed(AppConstants.mockSdkDelay);

    // Simulated 90% success rate, 10% mismatch/spoof detection
    final random = Random();
    final isSuccess = random.nextDouble() > 0.1;

    if (!isSuccess) {
      throw const SdkException(
        message: 'Face verification rejected: Liveness check score below threshold.',
        errorCode: 'ERR_LIVENESS_FAILED',
      );
    }

    final randomSimilarity = 0.92 + (random.nextDouble() * 0.07);
    final randomLiveness = 0.88 + (random.nextDouble() * 0.11);

    return FaceOtpResultDto(
      sessionId: 'sess_${DateTime.now().millisecondsSinceEpoch}',
      status: 'success',
      similarityScore: double.parse(randomSimilarity.toStringAsFixed(3)),
      livenessScore: double.parse(randomLiveness.toStringAsFixed(3)),
      token: 'jwt_face_otp_${DateTime.now().microsecondsSinceEpoch}',
      verifiedAtIso: DateTime.now().toIso8601String(),
    );
  }

  @override
  Future<bool> cancelVerification() async {
    return true;
  }
}

@Riverpod(keepAlive: true)
IFaceOtpSdkDataSource faceOtpSdkDataSource(Ref ref) {
  return FaceOtpSdkDataSource();
}
