import 'package:dio/dio.dart';
import 'package:flutter_core_base/core/config/app_config.dart';
import 'package:flutter_core_base/core/network/interceptors/auth_interceptor.dart';
import 'package:flutter_test/flutter_test.dart';

class RecordingAdapter implements HttpClientAdapter {
  final int statusCode;
  RequestOptions? requestOptions;

  RecordingAdapter({this.statusCode = 200});

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requestOptions = options;
    return ResponseBody.fromString(
      '{}',
      statusCode,
      headers: const {
        Headers.contentTypeHeader: ['application/json'],
      },
    );
  }
}

void main() {
  test('adds configured bearer token and client key to requests', () async {
    final adapter = RecordingAdapter();
    final replay = Dio(BaseOptions(baseUrl: 'https://api.example.test'))..httpClientAdapter = adapter;
    final dio = Dio(BaseOptions(baseUrl: 'https://api.example.test'))..httpClientAdapter = adapter;
    dio.interceptors.add(
      AuthInterceptor(
        readConfig: () => const AppConfig(appToken: 'token-value', clientKey: 'client-key-value'),
        readAccessToken: () => null,
        refreshSession: () async => null,
        replayClient: replay,
        baseUri: Uri.parse('https://api.example.test'),
      ),
    );

    await dio.get<void>('/posts');

    expect(adapter.requestOptions?.headers['Authorization'], 'Bearer token-value');
    expect(adapter.requestOptions?.headers['X-Client-Key'], 'client-key-value');
  });

  test('a 401 from our own API asks for a refresh exactly once', () async {
    final adapter = RecordingAdapter(statusCode: 401);
    final replay = Dio(BaseOptions(baseUrl: 'https://api.example.test'))..httpClientAdapter = adapter;
    final dio = Dio(BaseOptions(baseUrl: 'https://api.example.test'))..httpClientAdapter = adapter;
    var refreshCalls = 0;
    dio.interceptors.add(
      AuthInterceptor(
        readConfig: AppConfig.new,
        readAccessToken: () => null,
        refreshSession: () async {
          refreshCalls++;
          return null;
        },
        replayClient: replay,
        baseUri: Uri.parse('https://api.example.test'),
      ),
    );

    await expectLater(dio.get<void>('/posts'), throwsA(isA<DioException>()));

    expect(refreshCalls, 1);
  });

  test('a 401 from another origin does not trigger a refresh', () async {
    final adapter = RecordingAdapter(statusCode: 401);
    final replay = Dio(BaseOptions(baseUrl: 'https://api.example.test'))..httpClientAdapter = adapter;
    final dio = Dio(BaseOptions(baseUrl: 'https://api.example.test'))..httpClientAdapter = adapter;
    var refreshCalls = 0;
    dio.interceptors.add(
      AuthInterceptor(
        readConfig: AppConfig.new,
        readAccessToken: () => null,
        refreshSession: () async {
          refreshCalls++;
          return null;
        },
        replayClient: replay,
        baseUri: Uri.parse('https://api.example.test'),
      ),
    );

    await expectLater(dio.get<void>('https://other.example.test/posts'), throwsA(isA<DioException>()));

    expect(refreshCalls, 0);
  });
}
