import 'package:dio/dio.dart';
import 'package:flutter_core_base/core/config/app_config_controller.dart';
import 'package:flutter_core_base/core/constants/app_constants.dart';
import 'package:flutter_core_base/core/network/interceptors/logging_interceptor.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_dio_client.g.dart';

/// A Dio deliberately built **without** `AuthInterceptor`.
///
/// Two callers need it: the auth data source (a refresh request must not be
/// retried by the very interceptor that triggered it — that is an infinite
/// loop), and `AuthInterceptor` itself when replaying a request after a
/// successful refresh.
@Riverpod(keepAlive: true)
Future<Dio> authDio(Ref ref) async {
  final config = await ref.watch(appConfigControllerProvider.future);
  final dio = Dio(
    BaseOptions(
      baseUrl: config.baseUrl,
      connectTimeout: AppConstants.connectTimeout,
      receiveTimeout: AppConstants.receiveTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );
  dio.interceptors.add(LoggingInterceptor());
  ref.onDispose(() => dio.close());
  return dio;
}
