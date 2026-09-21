import 'package:dio/dio.dart';
import 'package:flutter_core_base/core/config/app_config_controller.dart';
import 'package:flutter_core_base/core/constants/app_constants.dart';
import 'package:flutter_core_base/core/network/auth_dio_client.dart';
import 'package:flutter_core_base/core/network/interceptors/auth_interceptor.dart';
import 'package:flutter_core_base/core/network/interceptors/logging_interceptor.dart';
import 'package:flutter_core_base/features/auth/presentation/controllers/auth_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_dio_client.g.dart';

/// The application's HTTP client.
///
/// Lives in `lib/app/` rather than `core/` because wiring `AuthInterceptor`
/// means reaching into the auth feature, and `core` is not allowed to know
/// features exist. Composition is the composition root's job.
@Riverpod(keepAlive: true)
Future<Dio> dioClient(Ref ref) async {
  final config = await ref.watch(appConfigControllerProvider.future);
  final replayClient = await ref.watch(authDioProvider.future);
  final auth = ref.read(authControllerProvider.notifier);

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
      readConfig: () => config,
      readAccessToken: () => auth.currentAccessToken,
      refreshSession: auth.refreshSession,
      replayClient: replayClient,
      baseUri: Uri.parse(config.baseUrl),
    ),
    LoggingInterceptor(),
  ]);

  // `force: false` so a config change does not kill requests already in flight.
  ref.onDispose(() => dio.close());
  return dio;
}
