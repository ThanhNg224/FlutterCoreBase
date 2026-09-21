import 'package:flutter_core_base/core/config/app_config.dart';
import 'package:flutter_core_base/core/config/app_environment.dart';
import 'package:flutter_core_base/core/config/dev_tools.dart';
import 'package:flutter_core_base/core/constants/api_endpoints.dart';
import 'package:flutter_core_base/core/constants/storage_keys.dart';
import 'package:flutter_core_base/core/errors/error_handler.dart';
import 'package:flutter_core_base/core/errors/failure.dart';
import 'package:flutter_core_base/core/logging/logging.dart';
import 'package:flutter_core_base/core/storage/local_storage_service.dart';
import 'package:flutter_core_base/core/storage/secure_storage_service.dart';
import 'package:flutter_core_base/core/storage/storage_providers.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_config_controller.g.dart';

const _log = AppLogger('AppConfig');

@Riverpod(keepAlive: true)
class AppConfigController extends _$AppConfigController {
  @override
  Future<AppConfig> build() async {
    final storage = ref.watch(localStorageServiceProvider);
    final secureStorage = ref.watch(secureStorageServiceProvider);
    final buildEnvironment = AppEnvironment.build;
    final useDev = storage.getBool(StorageKeys.useDevEnvironment) ?? (buildEnvironment == Environment.development);
    // A development build mocks the API by default, because the base ships
    // pointing at a placeholder host. Without this, a fresh clone deadlocks:
    // the route guard sends you to /login, login calls a domain that does not
    // resolve, and the switch that would fix it lives in Settings — which is
    // behind the guard you cannot get past. Production never mocks.
    final mockSdk = storage.getBool(StorageKeys.mockSdkMode) ?? (buildEnvironment == Environment.development);
    final credentials = await _readCredentialOverrides(storage, secureStorage);

    final env = useDev ? Environment.development : Environment.production;
    final baseUrl = useDev ? ApiEndpoints.devUrl : ApiEndpoints.prodUrl;

    return AppConfig(
      environment: env,
      mockSdkEnabled: mockSdk,
      baseUrl: baseUrl,
      appToken: credentials.appToken ?? _defaultTokenFor(useDev),
      clientKey: credentials.clientKey ?? _defaultClientKeyFor(useDev),
    );
  }

  String _defaultTokenFor(bool useDev) => useDev ? ApiEndpoints.defaultDevToken : ApiEndpoints.defaultProdToken;
  String _defaultClientKeyFor(bool useDev) =>
      useDev ? ApiEndpoints.defaultDevClientKey : ApiEndpoints.defaultProdClientKey;

  /// Rejects a runtime-config mutation when this build is not allowed to make
  /// one. Returns `null` when the caller may proceed.
  Left<Failure, void>? _rejectIfDevToolsDisabled(String attempt) {
    if (DevTools.isEnabled) return null;
    _log.warn(
      'runtime config mutation rejected',
      data: {'attempt': Redacted.unredacted(attempt, because: 'source-code literal, not user data')},
    );
    return const Left(Failure.devToolsDisabled());
  }

  Future<Either<Failure, void>> toggleEnvironment(bool useDev) async {
    final rejection = _rejectIfDevToolsDisabled('toggleEnvironment');
    if (rejection != null) return rejection;

    final storage = ref.read(localStorageServiceProvider);
    await storage.setBool(StorageKeys.useDevEnvironment, useDev);

    final env = useDev ? Environment.development : Environment.production;
    final baseUrl = useDev ? ApiEndpoints.devUrl : ApiEndpoints.prodUrl;
    final current = state.value;
    if (current == null) return const Right(null);
    final secureStorage = ref.read(secureStorageServiceProvider);
    final token = await secureStorage.read(StorageKeys.secureAppToken) ?? _defaultTokenFor(useDev);
    final clientKey = await secureStorage.read(StorageKeys.secureClientKey) ?? _defaultClientKeyFor(useDev);

    state = AsyncData(current.copyWith(environment: env, baseUrl: baseUrl, appToken: token, clientKey: clientKey));
    return const Right(null);
  }

  Future<Either<Failure, void>> toggleMockSdk(bool enabled) async {
    final rejection = _rejectIfDevToolsDisabled('toggleMockSdk');
    if (rejection != null) return rejection;

    final storage = ref.read(localStorageServiceProvider);
    await storage.setBool(StorageKeys.mockSdkMode, enabled);
    final current = state.value;
    if (current != null) {
      state = AsyncData(current.copyWith(mockSdkEnabled: enabled));
    }
    return const Right(null);
  }

  Future<Either<Failure, void>> clearCredentialOverrides() {
    final rejection = _rejectIfDevToolsDisabled('clearCredentialOverrides');
    if (rejection != null) return Future.value(rejection);

    return ErrorHandler.guard(() async {
      final secureStorage = ref.read(secureStorageServiceProvider);
      await secureStorage.delete(StorageKeys.secureAppToken);
      await secureStorage.delete(StorageKeys.secureClientKey);

      final current = state.value;
      if (current != null) {
        final useDev = current.environment == Environment.development;
        state = AsyncData(
          current.copyWith(
            appToken: _defaultTokenFor(useDev),
            clientKey: _defaultClientKeyFor(useDev),
          ),
        );
      }
    });
  }

  Future<Either<Failure, void>> updateCredentials({String? appToken, String? clientKey}) {
    final rejection = _rejectIfDevToolsDisabled('updateCredentials');
    if (rejection != null) return Future.value(rejection);

    return ErrorHandler.guard(() async {
      final secureStorage = ref.read(secureStorageServiceProvider);
      if (appToken != null) {
        await secureStorage.write(key: StorageKeys.secureAppToken, value: appToken);
      }
      if (clientKey != null) {
        await secureStorage.write(key: StorageKeys.secureClientKey, value: clientKey);
      }

      final current = state.value;
      if (current != null) {
        state = AsyncData(
          current.copyWith(
            appToken: appToken ?? current.appToken,
            clientKey: clientKey ?? current.clientKey,
          ),
        );
      }
    });
  }

  Future<({String? appToken, String? clientKey})> _readCredentialOverrides(
    ILocalStorageService storage,
    ISecureStorageService secureStorage,
  ) async {
    var appToken = await secureStorage.read(StorageKeys.secureAppToken);
    var clientKey = await secureStorage.read(StorageKeys.secureClientKey);
    final legacyAppToken = storage.getString(StorageKeys.legacyAppToken);
    final legacyClientKey = storage.getString(StorageKeys.legacyClientKey);

    if (appToken == null && legacyAppToken != null) {
      await secureStorage.write(key: StorageKeys.secureAppToken, value: legacyAppToken);
      appToken = legacyAppToken;
    }
    if (clientKey == null && legacyClientKey != null) {
      await secureStorage.write(key: StorageKeys.secureClientKey, value: legacyClientKey);
      clientKey = legacyClientKey;
    }

    if (legacyAppToken != null) {
      await storage.remove(StorageKeys.legacyAppToken);
    }
    if (legacyClientKey != null) {
      await storage.remove(StorageKeys.legacyClientKey);
    }

    return (appToken: appToken, clientKey: clientKey);
  }
}
