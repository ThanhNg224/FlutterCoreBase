import 'package:flutter_core_base/core/config/app_config.dart';
import 'package:flutter_core_base/core/constants/api_endpoints.dart';
import 'package:flutter_core_base/core/constants/storage_keys.dart';
import 'package:flutter_core_base/core/storage/storage_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_config_controller.g.dart';

@Riverpod(keepAlive: true)
class AppConfigController extends _$AppConfigController {
  @override
  AppConfig build() {
    final storage = ref.watch(localStorageServiceProvider);
    final useDev = storage.getBool(StorageKeys.useDevEnvironment) ?? false;
    final mockSdk = storage.getBool(StorageKeys.mockSdkMode) ?? false;
    final token = storage.getString(StorageKeys.appToken) ?? _defaultTokenFor(useDev);
    final clientKey = storage.getString(StorageKeys.clientKey) ?? ApiEndpoints.defaultProdClientKey;

    final env = useDev ? Environment.development : Environment.production;
    final baseUrl = useDev ? ApiEndpoints.devUrl : ApiEndpoints.prodUrl;

    return AppConfig(
      environment: env,
      mockSdkEnabled: mockSdk,
      baseUrl: baseUrl,
      appToken: token,
      clientKey: clientKey,
    );
  }

  String _defaultTokenFor(bool useDev) => useDev ? ApiEndpoints.defaultDevToken : ApiEndpoints.defaultProdToken;

  void toggleEnvironment(bool useDev) {
    final storage = ref.read(localStorageServiceProvider);
    storage.setBool(StorageKeys.useDevEnvironment, useDev);

    final env = useDev ? Environment.development : Environment.production;
    final baseUrl = useDev ? ApiEndpoints.devUrl : ApiEndpoints.prodUrl;
    final hasCustomToken = storage.getString(StorageKeys.appToken) != null;
    final token = hasCustomToken ? state.appToken : _defaultTokenFor(useDev);

    state = state.copyWith(environment: env, baseUrl: baseUrl, appToken: token);
  }

  void toggleMockSdk(bool enabled) {
    final storage = ref.read(localStorageServiceProvider);
    storage.setBool(StorageKeys.mockSdkMode, enabled);
    state = state.copyWith(mockSdkEnabled: enabled);
  }

  void clearCredentialOverrides() {
    final storage = ref.read(localStorageServiceProvider);
    storage.remove(StorageKeys.appToken);
    storage.remove(StorageKeys.clientKey);

    state = state.copyWith(
      appToken: _defaultTokenFor(state.environment == Environment.development),
      clientKey: ApiEndpoints.defaultProdClientKey,
    );
  }

  void updateCredentials({String? appToken, String? clientKey}) {
    final storage = ref.read(localStorageServiceProvider);
    if (appToken != null) {
      storage.setString(StorageKeys.appToken, appToken);
    }
    if (clientKey != null) {
      storage.setString(StorageKeys.clientKey, clientKey);
    }
    state = state.copyWith(
      appToken: appToken ?? state.appToken,
      clientKey: clientKey ?? state.clientKey,
    );
  }
}
