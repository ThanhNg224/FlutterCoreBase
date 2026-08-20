import 'package:shared_preferences/shared_preferences.dart';

/// Contract for local storage operations
abstract interface class ILocalStorageService {
  Future<bool> setString(String key, String value);
  String? getString(String key);
  Future<bool> setBool(String key, bool value);
  bool? getBool(String key);
  Future<bool> setDouble(String key, double value);
  double? getDouble(String key);
  Future<bool> remove(String key);
  Future<bool> clear();
}

/// SharedPreferences implementation of [ILocalStorageService]
class LocalStorageService implements ILocalStorageService {
  final SharedPreferences _prefs;

  LocalStorageService(this._prefs);

  @override
  Future<bool> setString(String key, String value) => _prefs.setString(key, value);

  @override
  String? getString(String key) => _prefs.getString(key);

  @override
  Future<bool> setBool(String key, bool value) => _prefs.setBool(key, value);

  @override
  bool? getBool(String key) => _prefs.getBool(key);

  @override
  Future<bool> setDouble(String key, double value) => _prefs.setDouble(key, value);

  @override
  double? getDouble(String key) => _prefs.getDouble(key);

  @override
  Future<bool> remove(String key) => _prefs.remove(key);

  @override
  Future<bool> clear() => _prefs.clear();
}
