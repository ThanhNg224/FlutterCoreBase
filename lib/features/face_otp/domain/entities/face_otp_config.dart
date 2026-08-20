import 'package:freezed_annotation/freezed_annotation.dart';

part 'face_otp_config.freezed.dart';

enum LivenessMode { passive3D, activeMotion, hybrid }

@freezed
abstract class FaceOtpConfig with _$FaceOtpConfig {
  const factory FaceOtpConfig({
    @Default(30) int timeoutSeconds,
    @Default(0.85) double livenessThreshold,
    @Default(LivenessMode.passive3D) LivenessMode livenessMode,
    @Default(true) bool recordSessionVideo,
  }) = _FaceOtpConfig;
}
