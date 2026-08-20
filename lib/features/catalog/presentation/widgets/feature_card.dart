import 'package:flutter/material.dart';
import 'package:flutter_core_base/core/theme/app_colors.dart';
import 'package:flutter_core_base/core/theme/app_spacing.dart';
import 'package:flutter_core_base/core/theme/app_typography.dart';
import 'package:flutter_core_base/core/widgets/app_card.dart';
import 'package:flutter_core_base/features/catalog/domain/sdk_feature.dart';
import 'package:go_router/go_router.dart';

class FeatureCard extends StatelessWidget {
  final SdkFeature feature;

  const FeatureCard({super.key, required this.feature});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppCard(
      onTap: feature.isEnabled
          ? () {
              context.push(feature.routePath);
            }
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: (feature.isEnabled ? AppColors.primary : Colors.grey)
                      .withValues(alpha: isDark ? 0.2 : 0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusM),
                ),
                child: Icon(
                  feature.icon,
                  color: feature.isEnabled
                      ? (isDark ? AppColors.primaryLight : AppColors.primary)
                      : Colors.grey,
                  size: 26,
                ),
              ),
              const Spacer(),
              if (!feature.isEnabled)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                  ),
                  child: Text(
                    'Coming Soon',
                    style: AppTypography.caption.copyWith(fontWeight: FontWeight.w600),
                  ),
                )
              else
                const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppColors.textSecondaryLight),
            ],
          ),
          const SizedBox(height: AppSpacing.m),
          Text(
            feature.title,
            style: AppTypography.titleLarge,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            feature.description,
            style: AppTypography.bodyMedium.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
          ),
          const SizedBox(height: AppSpacing.m),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: feature.tags.map((tag) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.15)),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusS),
                ),
                child: Text(
                  '#$tag',
                  style: AppTypography.caption.copyWith(fontWeight: FontWeight.w500),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
