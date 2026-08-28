import 'package:flutter/material.dart';
import 'package:flutter_core_base/core/extensions/context_extensions.dart';
import 'package:flutter_core_base/core/theme/app_semantic_colors.dart';
import 'package:flutter_core_base/core/theme/app_spacing.dart';
import 'package:flutter_core_base/core/theme/app_typography.dart';
import 'package:flutter_core_base/core/widgets/app_card.dart';
import 'package:flutter_core_base/features/catalog/domain/entities/catalog_feature.dart';
import 'package:go_router/go_router.dart';

class FeatureCard extends StatelessWidget {
  final CatalogFeature feature;

  const FeatureCard({super.key, required this.feature});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final iconColor = feature.isEnabled ? colors.brandAccent : colors.textHint;

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
                  color: iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusM),
                ),
                child: Icon(
                  _iconFor(feature.iconKey),
                  color: iconColor,
                  size: 26,
                ),
              ),
              const Spacer(),
              if (!feature.isEnabled)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: colors.track.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                  ),
                  child: Text(
                    l10n.comingSoon,
                    style: AppTypography.caption.copyWith(
                      color: colors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              else
                Icon(Icons.arrow_forward_ios_rounded, size: 16, color: colors.textHint),
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
              color: colors.textSecondary,
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
                  color: colors.surface,
                  border: Border.all(color: colors.border),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusS),
                ),
                child: Text(
                  '#$tag',
                  style: AppTypography.caption.copyWith(
                    color: colors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  IconData _iconFor(String iconKey) => switch (iconKey) {
    CatalogIconKeys.feed => Icons.dynamic_feed_rounded,
    CatalogIconKeys.settings => Icons.tune_rounded,
    CatalogIconKeys.architecture => Icons.architecture_rounded,
    _ => Icons.extension_rounded,
  };
}
