// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_config_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AppConfigController)
final appConfigControllerProvider = AppConfigControllerProvider._();

final class AppConfigControllerProvider extends $AsyncNotifierProvider<AppConfigController, AppConfig> {
  AppConfigControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appConfigControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appConfigControllerHash();

  @$internal
  @override
  AppConfigController create() => AppConfigController();
}

String _$appConfigControllerHash() => r'f1e3ae6cd59a44d57d94f11008d8b383658e649b';

abstract class _$AppConfigController extends $AsyncNotifier<AppConfig> {
  FutureOr<AppConfig> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<AppConfig>, AppConfig>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AppConfig>, AppConfig>,
              AsyncValue<AppConfig>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
