import 'package:flutter_core_base/core/config/app_config_controller.dart';
import 'package:dio/dio.dart';
import 'package:flutter_core_base/core/constants/app_constants.dart';
import 'package:flutter_core_base/core/network/interceptors/auth_interceptor.dart';
import 'package:flutter_core_base/core/network/interceptors/logging_interceptor.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dio_client.g.dart';

/// Configured Dio HTTP client provider
@riverpod
Future<Dio> dioClient(Ref ref) async {
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

  dio.interceptors.addAll([
    AuthInterceptor(
      readConfig: () => ref.read(appConfigControllerProvider).value ?? config,
      clearCredentialOverrides: () async {
        await ref.read(appConfigControllerProvider.notifier).clearCredentialOverrides();
      },
    ),
    LoggingInterceptor(),
  ]);

  ref.onDispose(() => dio.close(force: true));
  return dio;
}
