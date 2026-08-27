import 'package:flutter_core_base/core/errors/error_handler.dart';
import 'package:flutter_core_base/core/errors/failure.dart';
import 'package:flutter_core_base/core/logging/logging.dart';
import 'package:flutter_core_base/core/routing/route_paths.dart';
import 'package:flutter_core_base/features/catalog/domain/entities/catalog_feature.dart';
import 'package:flutter_core_base/features/catalog/domain/repositories/i_catalog_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'catalog_repository.g.dart';

const _log = AppLogger('CatalogRepository');

class CatalogRepository implements ICatalogRepository {
  @override
  Future<Either<Failure, List<CatalogFeature>>> getFeatures() {
    return ErrorHandler.guard(() async {
      await Future<void>.delayed(const Duration(milliseconds: 50));
      const features = [
        CatalogFeature(
          id: 'posts',
          title: 'Posts & Feed Demo',
          description: 'REST API CRUD, Riverpod AsyncNotifier, caching, pagination, and pull-to-refresh.',
          routePath: RoutePaths.posts,
          category: FeatureCategory.data,
          iconKey: CatalogIconKeys.feed,
          tags: ['REST API', 'Riverpod', 'CRUD', 'Pagination'],
        ),
        CatalogFeature(
          id: 'settings',
          title: 'Settings & Environment',
          description: 'Dynamic theme mode, multi-language i18n, Dev/Prod environments, and credential management.',
          routePath: RoutePaths.settings,
          category: FeatureCategory.config,
          iconKey: CatalogIconKeys.settings,
          tags: ['Theme', 'i18n', 'Dev/Prod', 'Redaction'],
        ),
        CatalogFeature(
          id: 'architecture',
          title: 'Clean Architecture Blueprint',
          description: 'Feature-First 3-layer architecture (Presentation, Domain, Data) with strict decoupling.',
          routePath: RoutePaths.catalog,
          category: FeatureCategory.ui,
          iconKey: CatalogIconKeys.architecture,
          isEnabled: false,
          tags: ['Clean Architecture', 'Freezed', 'fpdart'],
        ),
      ];
      _log.debug('catalog features loaded', data: {'count': Redacted.count(features.length)});
      return features;
    });
  }
}

@Riverpod(keepAlive: true)
ICatalogRepository catalogRepository(Ref ref) {
  return CatalogRepository();
}
