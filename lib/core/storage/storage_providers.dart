import 'package:flutter_core_base/core/storage/local_storage_service.dart';
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
