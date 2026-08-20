import 'package:flutter_core_base/core/errors/failure.dart';
import 'package:flutter_core_base/features/face_otp/domain/entities/face_otp_config.dart';
import 'package:flutter_core_base/features/face_otp/domain/entities/face_otp_result.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'face_otp_state.freezed.dart';

@freezed
abstract class FaceOtpState with _$FaceOtpState {
  const factory FaceOtpState.initial({
    @Default(FaceOtpConfig()) FaceOtpConfig config,
  }) = FaceOtpInitialState;

  const factory FaceOtpState.verifying({
    required FaceOtpConfig config,
    @Default('Initializing biometric camera...') String progressMessage,
  }) = FaceOtpVerifyingState;

  const factory FaceOtpState.success({
    required FaceOtpConfig config,
    required FaceOtpResult result,
  }) = FaceOtpSuccessState;

  const factory FaceOtpState.failure({
    required FaceOtpConfig config,
    required Failure failure,
  }) = FaceOtpFailureState;
}
