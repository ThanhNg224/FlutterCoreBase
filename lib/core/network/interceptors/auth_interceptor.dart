import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_core_base/core/config/app_config.dart';
import 'package:flutter_core_base/core/logging/logging.dart';

const _log = AppLogger('HTTP.Auth');

/// Adds runtime credentials to outgoing requests and clears overrides on 401.
class AuthInterceptor extends Interceptor {
  final AppConfig Function() readConfig;
  final Future<void> Function() clearCredentialOverrides;

  AuthInterceptor({
    required this.readConfig,
    required this.clearCredentialOverrides,
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final config = readConfig();
    if (config.appToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer ${config.appToken}';
    }
    if (config.clientKey.isNotEmpty) {
      options.headers['X-Client-Key'] = config.clientKey;
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode != 401) {
      handler.next(err);
      return;
    }

    unawaited(_clearCredentialsThenForward(err, handler));
  }

  Future<void> _clearCredentialsThenForward(
    DioException error,
    ErrorInterceptorHandler handler,
  ) async {
    try {
      await clearCredentialOverrides();
    } catch (exception, stackTrace) {
      _log.error(
        'failed to clear credential overrides after unauthorized response',
        error: exception,
        stackTrace: stackTrace,
        data: {'errorType': Redacted.type(exception)},
      );
    } finally {
      handler.next(error);
    }
  }
}
