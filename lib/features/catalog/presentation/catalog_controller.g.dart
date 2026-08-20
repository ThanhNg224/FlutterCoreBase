// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Auto-disposed controller managing SDK feature catalog list

@ProviderFor(CatalogController)
final catalogControllerProvider = CatalogControllerProvider._();

/// Auto-disposed controller managing SDK feature catalog list
final class CatalogControllerProvider
    extends $AsyncNotifierProvider<CatalogController, List<SdkFeature>> {
  /// Auto-disposed controller managing SDK feature catalog list
  CatalogControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'catalogControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$catalogControllerHash();

  @$internal
  @override
  CatalogController create() => CatalogController();
}

String _$catalogControllerHash() => r'679087cc840fcabba2a264519d8cf4fd03ba188a';

/// Auto-disposed controller managing SDK feature catalog list

abstract class _$CatalogController extends $AsyncNotifier<List<SdkFeature>> {
  FutureOr<List<SdkFeature>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<SdkFeature>>, List<SdkFeature>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<SdkFeature>>, List<SdkFeature>>,
              AsyncValue<List<SdkFeature>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
