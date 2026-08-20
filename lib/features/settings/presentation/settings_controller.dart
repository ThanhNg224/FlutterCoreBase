import 'package:flutter_core_base/core/constants/storage_keys.dart';
import 'package:flutter_core_base/core/storage/storage_providers.dart';
import 'package:flutter_core_base/features/settings/domain/app_settings.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_controller.g.dart';

@Riverpod(keepAlive: true)
class SettingsController extends _$SettingsController {
  @override
  AppSettings build() {
    final storage = ref.watch(localStorageServiceProvider);
    final envString = storage.getString(StorageKeys.environment);
    final isMock = storage.getBool(StorageKeys.mockSdkMode) ?? true;

    final env = switch (envString) {
      'staging' => Environment.staging,
      'production' => Environment.production,
      _ => Environment.development,
    };

    final baseUrl = switch (env) {
      Environment.production => 'https://api.kalapa.vn',
      Environment.staging => 'https://api-stg.kalapa.vn',
      Environment.development => 'https://api-dev.kalapa.vn',
    };

    return AppSettings(environment: env, mockSdkEnabled: isMock, baseUrl: baseUrl);
  }

  void updateEnvironment(Environment env) {
    final storage = ref.read(localStorageServiceProvider);
    storage.setString(StorageKeys.environment, env.name);

    final baseUrl = switch (env) {
      Environment.production => 'https://api.kalapa.vn',
      Environment.staging => 'https://api-stg.kalapa.vn',
      Environment.development => 'https://api-dev.kalapa.vn',
    };

    state = state.copyWith(environment: env, baseUrl: baseUrl);
  }

  void toggleMockSdk(bool enabled) {
    final storage = ref.read(localStorageServiceProvider);
    storage.setBool(StorageKeys.mockSdkMode, enabled);
    state = state.copyWith(mockSdkEnabled: enabled);
  }
}
