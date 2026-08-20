import 'package:flutter/material.dart';
import 'package:flutter_core_base/core/theme/app_colors.dart';
import 'package:flutter_core_base/core/theme/app_spacing.dart';
import 'package:flutter_core_base/core/theme/app_typography.dart';
import 'package:flutter_core_base/core/widgets/app_card.dart';
import 'package:flutter_core_base/features/face_otp/domain/entities/face_otp_result.dart';
import 'package:intl/intl.dart';

class VerificationResultCard extends StatelessWidget {
  final FaceOtpResult result;

  const VerificationResultCard({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('HH:mm:ss dd/MM/yyyy');

    return AppCard(
      color: AppColors.success.withValues(alpha: 0.06),
      border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.verified_rounded, color: AppColors.success, size: 28),
              const SizedBox(width: AppSpacing.s),
              Text(
                'Verification Successful',
                style: AppTypography.titleLarge.copyWith(color: AppColors.success),
              ),
            ],
          ),
          const Divider(height: AppSpacing.l),
          _buildInfoRow('Session ID:', result.sessionId),
          const SizedBox(height: AppSpacing.s),
          _buildInfoRow(
            'Similarity Score:',
            '${(result.similarityScore * 100).toStringAsFixed(1)}%',
            valueColor: AppColors.success,
            isBold: true,
          ),
          const SizedBox(height: AppSpacing.s),
          _buildInfoRow(
            'Liveness Score:',
            '${(result.livenessScore * 100).toStringAsFixed(1)}%',
            valueColor: AppColors.success,
            isBold: true,
          ),
          const SizedBox(height: AppSpacing.s),
          _buildInfoRow('Token:', result.token, isMonospace: true),
          const SizedBox(height: AppSpacing.s),
          _buildInfoRow('Timestamp:', dateFormat.format(result.verifiedAt)),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value, {
    Color? valueColor,
    bool isBold = false,
    bool isMonospace = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondaryLight),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTypography.bodyMedium.copyWith(
              color: valueColor,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
              fontFamily: isMonospace ? 'monospace' : null,
            ),
          ),
        ),
      ],
    );
  }
}
