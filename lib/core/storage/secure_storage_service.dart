import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Secure persistence contract for credential overrides only.
abstract interface class ISecureStorageService {
  Future<String?> read(String key);
  Future<void> write({required String key, required String value});
  Future<void> delete(String key);
}

/// [FlutterSecureStorage]-backed credential storage.
class SecureStorageService implements ISecureStorageService {
  final FlutterSecureStorage _storage;

  const SecureStorageService(this._storage);

  @override
  Future<String?> read(String key) => _storage.read(key: key);

  @override
  Future<void> write({required String key, required String value}) {
    return _storage.write(key: key, value: value);
  }

  @override
  Future<void> delete(String key) => _storage.delete(key: key);
}
