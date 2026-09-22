import 'package:flutter_core_base/core/storage/local_storage_service.dart';
import 'package:flutter_core_base/core/storage/secure_storage_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'storage_providers.g.dart';

/// Provider for SharedPreferences instance (initialized at startup)
@Riverpod(keepAlive: true)
SharedPreferences sharedPreferences(Ref ref) {
  throw UnimplementedError('SharedPreferences must be overridden in ProviderScope');
}

/// Provider for [ILocalStorageService]
@Riverpod(keepAlive: true)
ILocalStorageService localStorageService(Ref ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return LocalStorageService(prefs);
}

/// Provider for credential-only secure storage.
///
/// Explicit per-platform options — never rely on the package defaults for
/// something that stores the access token and refresh token.
///
/// Android: `flutter_secure_storage: ^11.2.0` no longer exposes an
/// `encryptedSharedPreferences` flag (that option existed pre-v10). The
/// plain `AndroidOptions()` default is already AES/GCM data encryption with
/// an RSA-OAEP-wrapped key on API 23+, which is what `encryptedSharedPreferences:
/// true` used to buy on older major versions — so it is declared explicitly
/// here instead of inherited implicitly from `FlutterSecureStorage()`.
///
/// iOS/macOS: `KeychainAccessibility.first_unlock_this_device` — tokens must
/// not leave the device via iCloud Keychain sync (the `_this_device` suffix
/// opts out of that), and the app does not need to read them before the
/// user's first unlock after a reboot (unlike, say, a VoIP or background-fetch
/// use case that would need `.first_unlock` without the device pin), so the
/// most restrictive non-device-bound-passcode option is used.
@Riverpod(keepAlive: true)
ISecureStorageService secureStorageService(Ref ref) {
  return const SecureStorageService(
    FlutterSecureStorage(
      aOptions: AndroidOptions(),
      iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock_this_device),
      mOptions: MacOsOptions(accessibility: KeychainAccessibility.first_unlock_this_device),
    ),
  );
}
