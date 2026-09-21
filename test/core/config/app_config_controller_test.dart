import 'package:flutter_core_base/core/config/app_config.dart';
import 'package:flutter_core_base/core/config/app_config_controller.dart';
import 'package:flutter_core_base/core/config/app_environment.dart';
import 'package:flutter_core_base/core/config/dev_tools.dart';
import 'package:flutter_core_base/core/constants/api_endpoints.dart';
import 'package:flutter_core_base/core/constants/storage_keys.dart';
import 'package:flutter_core_base/core/errors/failure.dart';
import 'package:flutter_core_base/core/storage/local_storage_service.dart';
import 'package:flutter_core_base/core/storage/secure_storage_service.dart';
import 'package:flutter_core_base/core/storage/storage_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakeSecureStorageService implements ISecureStorageService {
  final values = <String, String>{};

  @override
  Future<void> delete(String key) async {
    values.remove(key);
  }

  @override
  Future<String?> read(String key) async => values[key];

  @override
  Future<void> write({required String key, required String value}) async {
    values[key] = value;
  }
}

/// In-memory [ILocalStorageService] fake for tests that don't need real
/// SharedPreferences persistence — only the values a test explicitly sets.
class FakeLocalStorageService implements ILocalStorageService {
  final _bools = <String, bool>{};
  final _strings = <String, String>{};
  final _doubles = <String, double>{};
  final _ints = <String, int>{};
  final _stringLists = <String, List<String>>{};

  @override
  Future<bool> setString(String key, String value) async {
    _strings[key] = value;
    return true;
  }

  @override
  String? getString(String key) => _strings[key];

  @override
  Future<bool> setBool(String key, bool value) async {
    _bools[key] = value;
    return true;
  }

  @override
  bool? getBool(String key) => _bools[key];

  @override
  Future<bool> setDouble(String key, double value) async {
    _doubles[key] = value;
    return true;
  }

  @override
  double? getDouble(String key) => _doubles[key];

  @override
  Future<bool> setInt(String key, int value) async {
    _ints[key] = value;
    return true;
  }

  @override
  int? getInt(String key) => _ints[key];

  @override
  Future<bool> setStringList(String key, List<String> value) async {
    _stringLists[key] = value;
    return true;
  }

  @override
  List<String>? getStringList(String key) => _stringLists[key];

  @override
  Future<bool> remove(String key) async {
    _bools.remove(key);
    _strings.remove(key);
    _doubles.remove(key);
    _ints.remove(key);
    _stringLists.remove(key);
    return true;
  }

  @override
  Future<bool> clear() async {
    _bools.clear();
    _strings.clear();
    _doubles.clear();
    _ints.clear();
    _stringLists.clear();
    return true;
  }
}

/// Builds an isolated [ProviderContainer] backed by fakes, so tests that only
/// care about environment resolution don't need a real SharedPreferences
/// instance. Pass [storage] to seed a stored override.
ProviderContainer makeContainer({ILocalStorageService? storage}) {
  return ProviderContainer(
    overrides: [
      localStorageServiceProvider.overrideWithValue(storage ?? FakeLocalStorageService()),
      secureStorageServiceProvider.overrideWithValue(FakeSecureStorageService()),
    ],
  );
}

void main() {
  late SharedPreferences preferences;
  late FakeSecureStorageService secureStorage;
  late ProviderContainer container;

  setUp(() async {
    SharedPreferences.setMockInitialValues({
      StorageKeys.legacyAppToken: 'legacy-token',
      StorageKeys.legacyClientKey: 'legacy-client-key',
    });
    preferences = await SharedPreferences.getInstance();
    secureStorage = FakeSecureStorageService();
    container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(preferences),
        secureStorageServiceProvider.overrideWithValue(secureStorage),
      ],
    );
  });

  tearDown(() => container.dispose());
  tearDown(AppEnvironment.resetForTest);

  test('migrates plaintext credential overrides to secure storage', () async {
    final config = await container.read(appConfigControllerProvider.future);

    expect(config.appToken, 'legacy-token');
    expect(config.clientKey, 'legacy-client-key');
    expect(secureStorage.values[StorageKeys.secureAppToken], 'legacy-token');
    expect(secureStorage.values[StorageKeys.secureClientKey], 'legacy-client-key');
    expect(preferences.getString(StorageKeys.legacyAppToken), isNull);
    expect(preferences.getString(StorageKeys.legacyClientKey), isNull);
  });

  test('updates and clears secure credential overrides', () async {
    // Pinned: this test asserts a production environment at the end, which
    // used to be true unconditionally (`?? false`). Now that the build
    // environment is the default, it must be pinned rather than relying on
    // this repo's `default-flavor: dev` to happen to resolve elsewhere.
    AppEnvironment.setForTest(Environment.production);
    await container.read(appConfigControllerProvider.future);
    final controller = container.read(appConfigControllerProvider.notifier);

    final update = await controller.updateCredentials(appToken: 'updated-token');
    expect(update.isRight(), isTrue);
    expect(secureStorage.values[StorageKeys.secureAppToken], 'updated-token');
    expect(container.read(appConfigControllerProvider).value?.appToken, 'updated-token');

    final clear = await controller.clearCredentialOverrides();
    expect(clear.isRight(), isTrue);
    expect(secureStorage.values, isEmpty);
    expect(container.read(appConfigControllerProvider).value?.appToken, isEmpty);
    expect(container.read(appConfigControllerProvider).value?.environment, Environment.production);
  });

  test('does not expose credentials through string conversion', () {
    const config = AppConfig(appToken: 'private-token', clientKey: 'private-client-key');

    expect(config.toString(), isNot(contains('private-token')));
    expect(config.toString(), isNot(contains('private-client-key')));
  });

  group('environment defaults', () {
    tearDown(AppEnvironment.resetForTest);

    test('with no stored override, a production build starts on production', () async {
      // The environment must be pinned: this repo's `default-flavor: dev` makes
      // the ambient AppEnvironment.build under test `development`, so an
      // unpinned assertion would be testing pubspec.yaml, not this controller.
      AppEnvironment.setForTest(Environment.production);
      final container = makeContainer(); // use the helper already present in this file
      addTearDown(container.dispose);

      final config = await container.read(appConfigControllerProvider.future);

      expect(config.environment, Environment.production);
      expect(config.baseUrl, ApiEndpoints.prodUrl);
    });

    test('with no stored override, a dev build starts on dev', () async {
      AppEnvironment.setForTest(Environment.development);
      final container = makeContainer();
      addTearDown(container.dispose);

      final config = await container.read(appConfigControllerProvider.future);

      expect(config.environment, Environment.development);
      expect(config.baseUrl, ApiEndpoints.devUrl);
    });

    test('a stored override wins over the compiled environment', () async {
      AppEnvironment.setForTest(Environment.production);
      final storage = FakeLocalStorageService()..setBool(StorageKeys.useDevEnvironment, true);
      final container = makeContainer(storage: storage);
      addTearDown(container.dispose);

      final config = await container.read(appConfigControllerProvider.future);

      expect(config.environment, Environment.development);
      expect(config.baseUrl, ApiEndpoints.devUrl);
    });
  });

  group('mock mode defaults', () {
    tearDown(AppEnvironment.resetForTest);

    test('a dev build mocks by default so a fresh clone can get past login', () async {
      // Regression guard. The base ships pointing at a placeholder host, and the
      // route guard sends an unauthenticated user to /login. If a dev build did
      // not mock, login would call a domain that does not resolve, and the mock
      // switch — which lives in Settings, behind the guard — would be
      // unreachable. Cloning the repo would produce an app nobody can enter.
      AppEnvironment.setForTest(Environment.development);
      final container = makeContainer();
      addTearDown(container.dispose);

      final config = await container.read(appConfigControllerProvider.future);

      expect(config.mockSdkEnabled, isTrue);
    });

    test('a production build never mocks by default', () async {
      AppEnvironment.setForTest(Environment.production);
      final container = makeContainer();
      addTearDown(container.dispose);

      final config = await container.read(appConfigControllerProvider.future);

      expect(config.mockSdkEnabled, isFalse);
    });

    test('a stored preference wins over the build default in both directions', () async {
      AppEnvironment.setForTest(Environment.development);
      final off = makeContainer(storage: FakeLocalStorageService()..setBool(StorageKeys.mockSdkMode, false));
      addTearDown(off.dispose);
      expect((await off.read(appConfigControllerProvider.future)).mockSdkEnabled, isFalse);

      AppEnvironment.setForTest(Environment.production);
      final on = makeContainer(storage: FakeLocalStorageService()..setBool(StorageKeys.mockSdkMode, true));
      addTearDown(on.dispose);
      expect((await on.read(appConfigControllerProvider.future)).mockSdkEnabled, isTrue);
    });
  });

  test('rejects environment, mock and credential changes when dev tools are off', () async {
    DevTools.setEnabledForTest(false);
    addTearDown(DevTools.resetForTest);

    final container = makeContainer();
    addTearDown(container.dispose);
    final before = await container.read(appConfigControllerProvider.future);
    final notifier = container.read(appConfigControllerProvider.notifier);

    expect(await notifier.toggleEnvironment(true), isA<Left<Failure, void>>());
    expect(await notifier.toggleMockSdk(true), isA<Left<Failure, void>>());
    expect(await notifier.updateCredentials(appToken: 'x'), isA<Left<Failure, void>>());
    expect(await notifier.clearCredentialOverrides(), isA<Left<Failure, void>>());

    final after = container.read(appConfigControllerProvider).requireValue;
    expect(after, before, reason: 'a rejected mutation must not alter state');
  });
}
