import 'dart:convert';

import 'package:flutter_core_base/core/constants/storage_keys.dart';
import 'package:flutter_core_base/core/logging/logging.dart';
import 'package:flutter_core_base/core/storage/secure_storage_service.dart';
import 'package:flutter_core_base/core/storage/storage_providers.dart';
import 'package:flutter_core_base/features/auth/data/models/auth_session_dto.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_local_datasource.g.dart';

const _log = AppLogger('Auth.Storage');

abstract interface class IAuthLocalDataSource {
  Future<AuthSessionDto?> read();
  Future<void> write(AuthSessionDto session);
  Future<void> clear();
}

/// Session persistence. Tokens go to the Keychain / Keystore, never to
/// SharedPreferences.
class AuthLocalDataSource implements IAuthLocalDataSource {
  final ISecureStorageService storage;

  const AuthLocalDataSource(this.storage);

  @override
  Future<AuthSessionDto?> read() async {
    final raw = await storage.read(StorageKeys.secureAuthSession);
    if (raw == null || raw.isEmpty) return null;
    try {
      return AuthSessionDto.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (error) {
      // A session we cannot parse is a session we do not have. Drop it rather
      // than wedging every launch on a stale schema.
      _log.warn('discarding unreadable persisted session', data: {'errorType': Redacted.type(error)});
      await clear();
      return null;
    }
  }

  @override
  Future<void> write(AuthSessionDto session) {
    return storage.write(key: StorageKeys.secureAuthSession, value: jsonEncode(session.toJson()));
  }

  @override
  Future<void> clear() => storage.delete(StorageKeys.secureAuthSession);
}

@Riverpod(keepAlive: true)
IAuthLocalDataSource authLocalDataSource(Ref ref) {
  return AuthLocalDataSource(ref.watch(secureStorageServiceProvider));
}
