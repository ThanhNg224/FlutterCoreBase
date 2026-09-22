import 'package:dio/dio.dart';
import 'package:flutter_core_base/core/logging/logging.dart';

const _log = AppLogger('HTTP');

/// Logging interceptor for Dio HTTP requests.
/// Logs request/response metadata without logging request/response bodies to protect PII.
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _log.debug('➡️ ${options.method} request', data: {'url': _endpoint(options.uri)});
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    _log.debug(
      '⬅️ response ${response.statusCode}',
      data: {'url': _endpoint(response.requestOptions.uri)},
    );
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _log.error(
      '✖ request failed',
      data: {
        'type': Redacted.unredacted(err.type.name, because: 'DioExceptionType enum name'),
        'url': _endpoint(err.requestOptions.uri),
        'reason': Redacted.unredacted(_safeReason(err.type), because: 'fixed Dio failure category'),
      },
    );
    super.onError(err, handler);
  }

  static const _allowedQueryKeys = {
    'page',
    '_page',
    'limit',
    '_limit',
  };

  static final _nonNegativeDecimal = RegExp(r'^[0-9]+$');
  static const _maxPaginationDigits = 9;

  static Redacted _endpoint(Uri uri) {
    final cleanUri = uri.removeFragment().replace(userInfo: '');
    if (uri.queryParametersAll.isEmpty) {
      return Redacted.unredacted(cleanUri.toString(), because: 'endpoint path without query or payload');
    }

    final normalizedQuery = <String, List<String>>{};
    for (final entry in uri.queryParametersAll.entries) {
      normalizedQuery.putIfAbsent(entry.key.toLowerCase(), () => []).addAll(entry.value);
    }

    final sanitizedQuery = <String, String>{};
    for (final entry in normalizedQuery.entries) {
      final key = entry.key;
      final values = entry.value;
      final isAllowed = _allowedQueryKeys.contains(key);
      final hasOneSafeValue = values.length == 1 && _isSafeValue(key, values.single);
      sanitizedQuery[key] = isAllowed && hasOneSafeValue ? values.single : 'REDACTED';
    }

    final sanitizedUri = cleanUri.replace(
      queryParameters: sanitizedQuery.isNotEmpty ? sanitizedQuery : null,
    );
    return Redacted.unredacted(sanitizedUri.toString(), because: 'endpoint metadata with query allowlist');
  }

  static bool _isSafeValue(String key, String value) {
    return switch (key) {
      'page' ||
      '_page' ||
      'limit' ||
      '_limit' => value.length <= _maxPaginationDigits && _nonNegativeDecimal.hasMatch(value),
      _ => false,
    };
  }

  static String _safeReason(DioExceptionType type) {
    return switch (type) {
      DioExceptionType.cancel => 'cancelled',
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.transformTimeout => 'timeout',
      DioExceptionType.badCertificate => 'bad_certificate',
      DioExceptionType.connectionError => 'connection',
      DioExceptionType.badResponse => 'response',
      DioExceptionType.unknown => 'unknown',
    };
  }
}
