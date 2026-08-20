import 'package:flutter_core_base/features/catalog/data/catalog_repository.dart';
import 'package:flutter_core_base/features/catalog/domain/sdk_feature.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'catalog_controller.g.dart';

/// Auto-disposed controller managing SDK feature catalog list
@riverpod
class CatalogController extends _$CatalogController {
  @override
  FutureOr<List<SdkFeature>> build() async {
    final repository = ref.watch(catalogRepositoryProvider);
    return repository.getFeatures();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() {
      final repository = ref.read(catalogRepositoryProvider);
      return repository.getFeatures();
    });
  }
}
