import 'package:flutter_core_base/features/face_otp/data/repositories/face_otp_repository_impl.dart';
import 'package:flutter_core_base/features/face_otp/domain/entities/face_otp_config.dart';
import 'package:flutter_core_base/features/face_otp/presentation/state/face_otp_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'face_otp_controller.g.dart';

/// Auto-disposed controller managing Face OTP session and UI state
@riverpod
class FaceOtpController extends _$FaceOtpController {
  @override
  FaceOtpState build() {
    return const FaceOtpState.initial();
  }

  void updateLivenessThreshold(double threshold) {
    state = state.maybeMap(
      initial: (s) => s.copyWith(config: s.config.copyWith(livenessThreshold: threshold)),
      orElse: () => state,
    );
  }

  void updateLivenessMode(LivenessMode mode) {
    state = state.maybeMap(
      initial: (s) => s.copyWith(config: s.config.copyWith(livenessMode: mode)),
      orElse: () => state,
    );
  }

  void toggleVideoRecording(bool record) {
    state = state.maybeMap(
      initial: (s) => s.copyWith(config: s.config.copyWith(recordSessionVideo: record)),
      orElse: () => state,
    );
  }

  Future<void> startVerification() async {
    final currentConfig = state.maybeMap(
      initial: (s) => s.config,
      success: (s) => s.config,
      failure: (s) => s.config,
      orElse: () => const FaceOtpConfig(),
    );

    state = FaceOtpState.verifying(
      config: currentConfig,
      progressMessage: 'Verifying facial biometrics with SDK...',
    );

    final repository = ref.read(faceOtpRepositoryProvider);
    final resultOrFailure = await repository.startVerification(config: currentConfig);

    resultOrFailure.fold(
      (failure) {
        state = FaceOtpState.failure(config: currentConfig, failure: failure);
      },
      (result) {
        state = FaceOtpState.success(config: currentConfig, result: result);
      },
    );
  }

  void reset() {
    final currentConfig = state.maybeMap(
      initial: (s) => s.config,
      success: (s) => s.config,
      failure: (s) => s.config,
      orElse: () => const FaceOtpConfig(),
    );
    state = FaceOtpState.initial(config: currentConfig);
  }
}
