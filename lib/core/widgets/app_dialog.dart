import 'package:flutter/material.dart';
import 'package:flutter_core_base/core/theme/app_colors.dart';
import 'package:flutter_core_base/core/theme/app_spacing.dart';
import 'package:flutter_core_base/core/theme/app_typography.dart';
import 'package:flutter_core_base/core/widgets/app_button.dart';

/// Modal dialog helper for displaying success, error, or confirmation
abstract class AppDialog {
  static Future<void> showResultDialog({
    required BuildContext context,
    required String title,
    required String message,
    bool isSuccess = true,
    Widget? extraContent,
  }) {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusL)),
        contentPadding: AppSpacing.dialogPadding,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: (isSuccess ? AppColors.success : AppColors.error).withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isSuccess ? Icons.check_circle_rounded : Icons.error_rounded,
                color: isSuccess ? AppColors.success : AppColors.error,
                size: 36,
              ),
            ),
            const SizedBox(height: AppSpacing.m),
            Text(
              title,
              style: AppTypography.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.s),
            Text(
              message,
              style: AppTypography.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (extraContent != null) ...[
              const SizedBox(height: AppSpacing.m),
              extraContent,
            ],
            const SizedBox(height: AppSpacing.l),
            AppButton(
              label: 'Close',
              width: double.infinity,
              onPressed: () => Navigator.of(ctx).pop(),
            ),
          ],
        ),
      ),
    );
  }
}
