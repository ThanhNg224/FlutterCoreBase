import 'package:flutter/material.dart';
import 'package:flutter_core_base/core/routing/route_paths.dart';
import 'package:flutter_core_base/core/theme/app_spacing.dart';
import 'package:flutter_core_base/core/theme/app_typography.dart';
import 'package:flutter_core_base/core/widgets/async_value_widget.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('SDK Capability Catalog'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Settings',
            onPressed: () => context.push(RoutePaths.settings),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(catalogControllerProvider.notifier).refresh(),
        child: AsyncValueWidget(
          value: catalogState,
          data: (features) {
            return ListView(
              padding: AppSpacing.pagePadding,
              children: [
                Text(
                  'Explore SDK Features',
                  style: AppTypography.headlineMedium,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Select an integrated module below to configure parameters and trigger live SDK verification.',
                  style: AppTypography.bodyMedium.copyWith(color: Colors.grey),
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
