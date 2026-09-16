import 'package:dio/dio.dart';
import 'package:flutter_core_base/core/config/app_config.dart';
import 'package:flutter_core_base/core/logging/logging.dart';

const _log = AppLogger('HTTP.Auth');

/// Attaches credentials to outgoing requests and, on a 401 from our own API,
/// refreshes the session once and replays the request.
class AuthInterceptor extends Interceptor {
  /// Marks a request that has already been replayed, so a still-invalid token
  /// produces one extra round trip rather than an unbounded retry loop.
  static const String replayedKey = 'authInterceptor.replayed';

  final AppConfig Function() readConfig;

  /// The signed-in user's access token, or `null` when nobody is signed in.
  final String? Function() readAccessToken;

  /// Obtains a fresh access token, or `null` when the session is unrecoverable.
  /// Expected to be single-flight on the caller's side.
  final Future<String?> Function() refreshSession;

  /// An interceptor-free Dio used to replay the failed request. Replaying on
  /// the intercepted client would re-enter this interceptor.
  final Dio replayClient;

  final Uri baseUri;

  AuthInterceptor({
    required this.readConfig,
    required this.readAccessToken,
    required this.refreshSession,
    required this.replayClient,
    required this.baseUri,
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _applyCredentials(options);
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final options = err.requestOptions;
    final isRetryable =
        err.response?.statusCode == 401 && _isCurrentApiRequest(options.uri) && options.extra[replayedKey] != true;

    if (!isRetryable) {
      handler.next(err);
      return;
    }

    _refreshAndReplay(err, handler);
  }

  Future<void> _refreshAndReplay(DioException err, ErrorInterceptorHandler handler) async {
    String? token;
    try {
      token = await refreshSession();
    } catch (error, stackTrace) {
      _log.error('session refresh threw', error: error, stackTrace: stackTrace);
      handler.next(err);
      return;
    }

    if (token == null) {
      _log.warn('session refresh produced no token; surfacing the original 401');
      handler.next(err);
      return;
    }

    final options = err.requestOptions
      ..extra[replayedKey] = true
      ..headers['Authorization'] = 'Bearer $token';

    try {
      final response = await replayClient.fetch<dynamic>(options);
      handler.resolve(response);
    } on DioException catch (replayError) {
      handler.next(replayError);
    } catch (error, stackTrace) {
      _log.error('request replay failed', error: error, stackTrace: stackTrace);
      handler.next(err);
    }
  }

  void _applyCredentials(RequestOptions options) {
    final config = readConfig();
    // A real session outranks the developer's configured app token.
    final token = readAccessToken() ?? (config.appToken.isNotEmpty ? config.appToken : null);
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    if (config.clientKey.isNotEmpty) {
      options.headers['X-Client-Key'] = config.clientKey;
    }
  }

  bool _isCurrentApiRequest(Uri requestUri) {
    if (requestUri.scheme != baseUri.scheme || requestUri.host != baseUri.host || requestUri.port != baseUri.port) {
      return false;
    }

    final basePath = baseUri.path.endsWith('/') ? baseUri.path.substring(0, baseUri.path.length - 1) : baseUri.path;
    return basePath.isEmpty ||
        basePath == '/' ||
        requestUri.path == basePath ||
        requestUri.path.startsWith('$basePath/');
  }
}
