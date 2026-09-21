// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'storage_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for SharedPreferences instance (initialized at startup)

@ProviderFor(sharedPreferences)
final sharedPreferencesProvider = SharedPreferencesProvider._();

/// Provider for SharedPreferences instance (initialized at startup)

final class SharedPreferencesProvider
    extends $FunctionalProvider<SharedPreferences, SharedPreferences, SharedPreferences>
    with $Provider<SharedPreferences> {
  /// Provider for SharedPreferences instance (initialized at startup)
  SharedPreferencesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sharedPreferencesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sharedPreferencesHash();

  @$internal
  @override
  $ProviderElement<SharedPreferences> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SharedPreferences create(Ref ref) {
    return sharedPreferences(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SharedPreferences value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SharedPreferences>(value),
    );
  }
}

String _$sharedPreferencesHash() => r'bb7c83146321d724b5288d27d7794bc5211d8b45';

/// Provider for [ILocalStorageService]

@ProviderFor(localStorageService)
final localStorageServiceProvider = LocalStorageServiceProvider._();

/// Provider for [ILocalStorageService]

final class LocalStorageServiceProvider
    extends $FunctionalProvider<ILocalStorageService, ILocalStorageService, ILocalStorageService>
    with $Provider<ILocalStorageService> {
  /// Provider for [ILocalStorageService]
  LocalStorageServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localStorageServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localStorageServiceHash();

  @$internal
  @override
  $ProviderElement<ILocalStorageService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ILocalStorageService create(Ref ref) {
    return localStorageService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ILocalStorageService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ILocalStorageService>(value),
    );
  }
}

String _$localStorageServiceHash() => r'0bec02a3d785041682b82b4b41994e7613e9e834';

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

@ProviderFor(secureStorageService)
final secureStorageServiceProvider = SecureStorageServiceProvider._();

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

final class SecureStorageServiceProvider
    extends $FunctionalProvider<ISecureStorageService, ISecureStorageService, ISecureStorageService>
    with $Provider<ISecureStorageService> {
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
  SecureStorageServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'secureStorageServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$secureStorageServiceHash();

  @$internal
  @override
  $ProviderElement<ISecureStorageService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ISecureStorageService create(Ref ref) {
    return secureStorageService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ISecureStorageService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ISecureStorageService>(value),
    );
  }
}

String _$secureStorageServiceHash() => r'9d63aad03c5a2617808b78a2e7eb7df77f869461';
