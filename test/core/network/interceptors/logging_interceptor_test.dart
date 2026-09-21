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

  test('preserves allowed query parameters like pagination in logs', () async {
    final dio = Dio()..httpClientAdapter = RecordingAdapter();
    dio.interceptors.add(LoggingInterceptor());

    await dio.get<void>('https://api.example.com/posts?_page=1&_limit=10&sort=desc');

    expect(sink.records, isNotEmpty);
    final logMessage = sink.formatted.first;

    expect(logMessage, contains('_page=1'));
    expect(logMessage, contains('_limit=10'));
    expect(logMessage, contains('sort=desc'));
    expect(logMessage, isNot(contains('REDACTED')));
  });
}
