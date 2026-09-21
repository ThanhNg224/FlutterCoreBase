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
        'reason': Redacted.unredacted(
          err.message ?? 'no message',
          because: 'Dio summary message',
        ),
      },
    );
    super.onError(err, handler);
  }

  static const _allowedQueryKeys = {
    'page',
    '_page',
    'limit',
    '_limit',
    'sort',
    'order',
    'filter',
  };

  static Redacted _endpoint(Uri uri) {
    if (uri.queryParameters.isEmpty) {
      final cleanUri = uri.hasFragment ? uri.removeFragment() : uri;
      return Redacted.unredacted(cleanUri.toString(), because: 'endpoint path without query or payload');
    }

    final sanitizedQuery = <String, String>{};
    for (final entry in uri.queryParameters.entries) {
      if (_allowedQueryKeys.contains(entry.key.toLowerCase())) {
        sanitizedQuery[entry.key] = entry.value;
      } else {
        sanitizedQuery[entry.key] = 'REDACTED';
      }
    }

    final cleanUri = uri.hasFragment ? uri.removeFragment() : uri;
    final sanitizedUri = cleanUri.replace(
      queryParameters: sanitizedQuery.isNotEmpty ? sanitizedQuery : null,
    );
    return Redacted.unredacted(sanitizedUri.toString(), because: 'endpoint metadata with query allowlist');
  }
}
