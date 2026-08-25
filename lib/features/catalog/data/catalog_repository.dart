import 'package:flutter/material.dart';
import 'package:flutter_core_base/core/routing/route_paths.dart';
import 'package:flutter_core_base/features/catalog/domain/sdk_feature.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'catalog_repository.g.dart';

abstract interface class ICatalogRepository {
  Future<List<SdkFeature>> getFeatures();
}

class CatalogRepository implements ICatalogRepository {
  @override
  Future<List<SdkFeature>> getFeatures() async {
    await Future<void>.delayed(const Duration(milliseconds: 50));
    return const [
      SdkFeature(
        id: 'posts',
        title: 'Posts & Feed Demo',
        description: 'REST API CRUD, Riverpod AsyncNotifier, caching, pagination, and pull-to-refresh.',
        routePath: RoutePaths.posts,
        category: FeatureCategory.data,
        icon: Icons.dynamic_feed_rounded,
        tags: ['REST API', 'Riverpod', 'CRUD', 'Pagination'],
      ),
      SdkFeature(
        id: 'settings',
        title: 'Settings & Environment',
        description: 'Dynamic theme mode, multi-language i18n, Dev/Prod environments, and credential management.',
        routePath: RoutePaths.settings,
        category: FeatureCategory.config,
        icon: Icons.tune_rounded,
        tags: ['Theme', 'i18n', 'Dev/Prod', 'Redaction'],
      ),
      SdkFeature(
        id: 'architecture',
        title: 'Clean Architecture Blueprint',
        description: 'Feature-First 3-layer architecture (Presentation, Domain, Data) with strict decoupling.',
        routePath: RoutePaths.catalog,
        category: FeatureCategory.ui,
        icon: Icons.architecture_rounded,
        isEnabled: false,
        tags: ['Clean Architecture', 'Freezed', 'fpdart'],
      ),
    ];
  }
}

@Riverpod(keepAlive: true)
ICatalogRepository catalogRepository(Ref ref) {
  return CatalogRepository();
}
