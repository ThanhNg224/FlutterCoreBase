import 'package:dio/dio.dart';
import 'package:flutter_core_base/core/logging/logging.dart';
import 'package:flutter_core_base/core/network/interceptors/logging_interceptor.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../support/recording_log_sink.dart';

class RecordingAdapter implements HttpClientAdapter {
  final int statusCode;

  RecordingAdapter({this.statusCode = 200});

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    return ResponseBody.fromString(
      '{"status": "ok"}',
      statusCode,
      headers: const {
        Headers.contentTypeHeader: ['application/json'],
      },
    );
  }
}

class FailingAdapter implements HttpClientAdapter {
  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    throw DioException(
      requestOptions: options,
      type: DioExceptionType.badResponse,
      message: 'token=secret123 url=https://private.example.test/account',
    );
  }
}

void main() {
  late RecordingLogSink sink;

  setUp(() {
    sink = RecordingLogSink();
    AppLogger.installForTest(
      policy: const LogPolicy(isDebugBuild: true, minimumLevel: LogLevel.debug),
      sink: sink,
    );
  });

  tearDown(AppLogger.restoreDefaults);

  test('redacts sensitive query parameters from logged URL', () async {
    final dio = Dio()..httpClientAdapter = RecordingAdapter();
    dio.interceptors.add(LoggingInterceptor());

    await dio.get<void>('https://api.example.com/items?token=secret123&email=user@test.com&page=2#section');

    expect(sink.records, isNotEmpty);
    final logMessage = sink.formatted.first;

    expect(logMessage, contains('page=2'));
    expect(logMessage, isNot(contains('secret123')));
    expect(logMessage, isNot(contains('user@test.com')));
    expect(logMessage, isNot(contains('#section')));
    expect(logMessage, contains('token=REDACTED'));
    expect(logMessage, contains('email=REDACTED'));
  });

  test('redacts repeated or invalid allowlisted values and removes filter from allowlist', () async {
    final dio = Dio()..httpClientAdapter = RecordingAdapter();
    dio.interceptors.add(LoggingInterceptor());

    await dio.get<void>(
      'https://api.example.com/items?page=2&page=3&_limit=-1&limit=10&sort=desc!&order=asc&filter=secret',
    );

    final logMessage = sink.formatted.first;

    expect(logMessage, contains('page=REDACTED'));
    expect(logMessage, contains('_limit=REDACTED'));
    expect(logMessage, contains('sort=REDACTED'));
    expect(logMessage, contains('order=REDACTED'));
    expect(logMessage, contains('filter=REDACTED'));
    expect(logMessage, isNot(contains('desc!')));
    expect(logMessage, isNot(contains('secret')));
  });

  test('redacts sort and order because the template has no value enum', () async {
    final dio = Dio()..httpClientAdapter = RecordingAdapter();
    dio.interceptors.add(LoggingInterceptor());

    await dio.get<void>('https://api.example.com/items?sort=desc&order=created_at-2');

    final logMessage = sink.formatted.first;

    expect(logMessage, contains('sort=REDACTED'));
    expect(logMessage, contains('order=REDACTED'));
    expect(logMessage, isNot(contains('desc')));
    expect(logMessage, isNot(contains('created_at-2')));
  });

  test('redacts pagination values longer than nine decimal digits', () async {
    final dio = Dio()..httpClientAdapter = RecordingAdapter();
    dio.interceptors.add(LoggingInterceptor());

    await dio.get<void>('https://api.example.com/items?page=123456789&limit=1234567890');

    final logMessage = sink.formatted.first;

    expect(logMessage, contains('page=123456789'));
    expect(logMessage, contains('limit=REDACTED'));
    expect(logMessage, isNot(contains('1234567890')));
  });

  test('normalizes query keys before duplicate detection', () async {
    final dio = Dio()..httpClientAdapter = RecordingAdapter();
    dio.interceptors.add(LoggingInterceptor());

    await dio.get<void>('https://api.example.com/items?page=2&PAGE=3');

    final logMessage = sink.formatted.first;

    expect(logMessage, contains('page=REDACTED'));
    expect(logMessage, isNot(contains('page=2')));
    expect(logMessage, isNot(contains('PAGE=3')));
  });

  test('removes URI user info as well as fragments from logged endpoint', () async {
    final dio = Dio()..httpClientAdapter = RecordingAdapter();
    dio.interceptors.add(LoggingInterceptor());

    await dio.get<void>('https://alice:secret123@api.example.com/items?page=2#private');

    final logMessage = sink.formatted.first;

    expect(logMessage, contains('https://api.example.com/items?page=2'));
    expect(logMessage, isNot(contains('alice')));
    expect(logMessage, isNot(contains('secret123')));
    expect(logMessage, isNot(contains('#private')));
  });

  test('preserves allowed query parameters like pagination in logs', () async {
    final dio = Dio()..httpClientAdapter = RecordingAdapter();
    dio.interceptors.add(LoggingInterceptor());

    await dio.get<void>('https://api.example.com/posts?_page=1&_limit=10&sort=desc');

    expect(sink.records, isNotEmpty);
    final logMessage = sink.formatted.first;

    expect(logMessage, contains('_page=1'));
    expect(logMessage, contains('_limit=10'));
    expect(logMessage, contains('sort=REDACTED'));
    expect(logMessage, isNot(contains('desc')));
  });

  test('does not log a raw DioException message', () async {
    final dio = Dio()..httpClientAdapter = FailingAdapter();
    dio.interceptors.add(LoggingInterceptor());

    await expectLater(dio.get<void>('https://api.example.com/items'), throwsA(isA<DioException>()));

    final logMessage = sink.formatted.join('\n');
    expect(logMessage, isNot(contains('token=secret123')));
    expect(logMessage, isNot(contains('private.example.test')));
    expect(logMessage, contains('reason=response'));
    expect(logMessage, contains('type=badResponse'));
  });
}
