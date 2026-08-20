import 'package:flutter/material.dart';
import 'package:flutter_core_base/core/theme/app_colors.dart';
import 'package:flutter_core_base/core/theme/app_spacing.dart';
import 'package:flutter_core_base/core/theme/app_typography.dart';
import 'package:flutter_core_base/core/widgets/app_button.dart';
import 'package:flutter_core_base/core/widgets/app_card.dart';
import 'package:flutter_core_base/core/widgets/app_dialog.dart';
import 'package:flutter_core_base/features/face_otp/domain/entities/face_otp_config.dart';
import 'package:flutter_core_base/features/face_otp/presentation/controllers/face_otp_controller.dart';
import 'package:flutter_core_base/features/face_otp/presentation/state/face_otp_state.dart';
import 'package:flutter_core_base/features/face_otp/presentation/views/widgets/verification_result_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FaceOtpScreen extends ConsumerWidget {
  const FaceOtpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(faceOtpControllerProvider);
    final controller = ref.read(faceOtpControllerProvider.notifier);

    // Listen for failure state to present error dialog
    ref.listen<FaceOtpState>(faceOtpControllerProvider, (prev, next) {
      if (next is FaceOtpFailureState) {
        AppDialog.showResultDialog(
          context: context,
          title: 'Verification Failed',
          message: next.failure.message,
          isSuccess: false,
        );
      }
    });

    final currentConfig = state.config;
    final isVerifying = state is FaceOtpVerifyingState;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Face OTP Demo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Reset Session',
            onPressed: isVerifying ? null : controller.reset,
          ),
        ],
      ),
      body: ListView(
        padding: AppSpacing.pagePadding,
        children: [
          // Banner
          AppCard(
            color: AppColors.primary.withValues(alpha: 0.08),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
            child: Row(
              children: [
                const Icon(Icons.security_rounded, color: AppColors.primary, size: 36),
                const SizedBox(width: AppSpacing.m),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('SDK Host Wrapper Mode', style: AppTypography.titleMedium),
                      const SizedBox(height: 2),
                      Text(
                        'This module triggers biometric face match & liveness check with isolated domain boundaries.',
                        style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondaryLight),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.l),

          // Configuration Card
          Text('SDK Configuration Parameters', style: AppTypography.titleLarge),
          const SizedBox(height: AppSpacing.s),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Liveness Threshold Slider
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Liveness Threshold', style: AppTypography.titleMedium),
                    Text(
                      '${(currentConfig.livenessThreshold * 100).toInt()}%',
                      style: AppTypography.titleMedium.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Slider(
                  value: currentConfig.livenessThreshold,
                  min: 0.50,
                  max: 0.99,
                  divisions: 49,
                  onChanged: isVerifying ? null : controller.updateLivenessThreshold,
                ),
                const Divider(height: AppSpacing.m),

                // Liveness Mode
                Text('Liveness Detection Mode', style: AppTypography.titleMedium),
                const SizedBox(height: AppSpacing.s),
                SegmentedButton<LivenessMode>(
                  segments: const [
                    ButtonSegment(value: LivenessMode.passive3D, label: Text('Passive 3D')),
                    ButtonSegment(value: LivenessMode.activeMotion, label: Text('Active Motion')),
                    ButtonSegment(value: LivenessMode.hybrid, label: Text('Hybrid')),
                  ],
                  selected: {currentConfig.livenessMode},
                  onSelectionChanged: isVerifying
                      ? null
                      : (newSet) {
                          controller.updateLivenessMode(newSet.first);
                        },
                ),
                const SizedBox(height: AppSpacing.m),

                // Video record toggle
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  title: Text('Record Session Video', style: AppTypography.titleMedium),
                  subtitle: const Text('Capture encrypted video for audit log'),
                  value: currentConfig.recordSessionVideo,
                  onChanged: isVerifying ? null : controller.toggleVideoRecording,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.l),

          // Verification Results (if success)
          if (state is FaceOtpSuccessState) ...[
            VerificationResultCard(result: state.result),
            const SizedBox(height: AppSpacing.l),
          ],

          // Trigger Button
          AppButton(
            label: isVerifying ? 'Verifying Biometrics...' : 'Start Face OTP Verification',
            icon: Icons.camera_front_rounded,
            isLoading: isVerifying,
            width: double.infinity,
            onPressed: controller.startVerification,
          ),
        ],
      ),
    );
  }
}
