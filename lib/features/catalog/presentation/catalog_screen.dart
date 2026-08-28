import 'package:flutter/material.dart';
import 'package:flutter_core_base/core/extensions/context_extensions.dart';
import 'package:flutter_core_base/core/routing/route_paths.dart';
import 'package:flutter_core_base/core/theme/app_semantic_colors.dart';
import 'package:flutter_core_base/core/theme/app_spacing.dart';
import 'package:flutter_core_base/core/theme/app_typography.dart';
import 'package:flutter_core_base/core/widgets/async_value_widget.dart';
import 'package:flutter_core_base/core/widgets/app_shimmer.dart';
import 'package:flutter_core_base/features/catalog/presentation/catalog_controller.dart';
import 'package:flutter_core_base/features/catalog/presentation/widgets/feature_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Catalog Home Screen showcasing SDK modules
class CatalogScreen extends ConsumerWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalogState = ref.watch(catalogControllerProvider);
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.catalogTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: l10n.settingsTooltip,
            onPressed: () => context.push(RoutePaths.settings),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(catalogControllerProvider.notifier).refresh(),
        child: AsyncValueWidget(
          value: catalogState,
          loading: AppShimmerList.new,
          data: (features) {
            return ListView(
              padding: AppSpacing.pagePadding,
              children: [
                Text(
                  l10n.exploreSdkFeaturesTitle,
                  style: AppTypography.headlineMedium,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  l10n.exploreSdkFeaturesSubtitle,
                  style: AppTypography.bodyMedium.copyWith(color: context.colors.textSecondary),
                ),
                const SizedBox(height: AppSpacing.l),
                ...features.map((feature) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.m),
                    child: FeatureCard(feature: feature),
                  );
                }),
              ],
            );
          },
        ),
      ),
    );
  }
}
