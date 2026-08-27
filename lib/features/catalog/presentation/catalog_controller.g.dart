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
    extends $AsyncNotifierProvider<CatalogController, List<CatalogFeature>> {
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

String _$catalogControllerHash() => r'6de42c48772a91a4bee7a02bca214c4f6a40fd3e';

/// Auto-disposed controller managing SDK feature catalog list

abstract class _$CatalogController
    extends $AsyncNotifier<List<CatalogFeature>> {
  FutureOr<List<CatalogFeature>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<List<CatalogFeature>>, List<CatalogFeature>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<CatalogFeature>>,
                List<CatalogFeature>
              >,
              AsyncValue<List<CatalogFeature>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
