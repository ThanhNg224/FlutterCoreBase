import 'package:flutter_core_base/features/catalog/data/repositories/catalog_repository.dart';
import 'package:flutter_core_base/features/catalog/domain/entities/catalog_feature.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'catalog_controller.g.dart';

/// Auto-disposed controller managing SDK feature catalog list
@riverpod
class CatalogController extends _$CatalogController {
  @override
  FutureOr<List<CatalogFeature>> build() async {
    final repository = ref.watch(catalogRepositoryProvider);
    final result = await repository.getFeatures();
    return result.fold((failure) => throw failure, (features) => features);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(catalogRepositoryProvider);
      final result = await repository.getFeatures();
      return result.fold((failure) => throw failure, (features) => features);
    });
  }
}
