import 'package:dio/dio.dart';
import 'package:flutter_core_base/core/config/app_config.dart';
import 'package:flutter_core_base/core/network/interceptors/auth_interceptor.dart';
import 'package:flutter_test/flutter_test.dart';

/// Answers 401 until [failFirst] requests have been served, then 200.
/// Records every Authorization header it saw.
class _SequencedAdapter implements HttpClientAdapter {
  _SequencedAdapter({required this.failFirst});

  final int failFirst;
  int calls = 0;
  final List<String?> seenAuthorization = [];

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    calls++;
    seenAuthorization.add(options.headers['Authorization'] as String?);
    final status = calls <= failFirst ? 401 : 200;
    return ResponseBody.fromString(
      '{}',
      status,
      headers: const {
        Headers.contentTypeHeader: ['application/json'],
      },
    );
  }
}

void main() {
  const baseUrl = 'https://api.example.test';

  ({Dio dio, _SequencedAdapter adapter}) build({
    required int failFirst,
    required String? Function() token,
    required Future<String?> Function() refresh,
  }) {
    final adapter = _SequencedAdapter(failFirst: failFirst);
    final replay = Dio(BaseOptions(baseUrl: baseUrl))..httpClientAdapter = adapter;
    final dio = Dio(BaseOptions(baseUrl: baseUrl))..httpClientAdapter = adapter;
    dio.interceptors.add(
      AuthInterceptor(
        readConfig: AppConfig.new,
        readAccessToken: token,
        refreshSession: refresh,
        replayClient: replay,
        baseUri: Uri.parse(baseUrl),
      ),
    );
    return (dio: dio, adapter: adapter);
  }

  test('a 401 triggers one refresh and the request is replayed with the new token', () async {
    var refreshes = 0;
    var token = 'old-token';
    final harness = build(
      failFirst: 1,
      token: () => token,
      refresh: () async {
        refreshes++;
        token = 'new-token';
        return token;
      },
    );

    final response = await harness.dio.get<void>('/posts');

    expect(response.statusCode, 200);
    expect(refreshes, 1);
    expect(harness.adapter.calls, 2, reason: 'original request plus one replay');
    expect(harness.adapter.seenAuthorization.last, 'Bearer new-token');
  });

  test('a failed refresh surfaces the original 401 without replaying', () async {
    var refreshes = 0;
    final harness = build(
      failFirst: 99,
      token: () => 'old-token',
      refresh: () async {
        refreshes++;
        return null;
      },
    );

    await expectLater(harness.dio.get<void>('/posts'), throwsA(isA<DioException>()));

    expect(refreshes, 1);
    expect(harness.adapter.calls, 1, reason: 'no replay when there is no new token');
  });

  test('a replayed request that 401s again is not retried a second time', () async {
    var refreshes = 0;
    final harness = build(
      failFirst: 99,
      token: () => 'old-token',
      refresh: () async {
        refreshes++;
        return 'still-bad';
      },
    );

    await expectLater(harness.dio.get<void>('/posts'), throwsA(isA<DioException>()));

    expect(refreshes, 1, reason: 'one refresh attempt, not an infinite loop');
    expect(harness.adapter.calls, 2, reason: 'original plus exactly one replay');
  });

  test('a 401 from another origin is left alone', () async {
    var refreshes = 0;
    final harness = build(
      failFirst: 99,
      token: () => 'old-token',
      refresh: () async {
        refreshes++;
        return 'new';
      },
    );

    await expectLater(
      harness.dio.get<void>('https://other.example.test/posts'),
      throwsA(isA<DioException>()),
    );

    expect(refreshes, 0);
  });

  test('the session access token takes precedence over the config app token', () async {
    final harness = build(
      failFirst: 0,
      token: () => 'session-token',
      refresh: () async => null,
    );

    await harness.dio.get<void>('/posts');

    expect(harness.adapter.seenAuthorization.single, 'Bearer session-token');
  });

  test('falls back to the configured app token when there is no session', () async {
    final adapter = _SequencedAdapter(failFirst: 0);
    final replay = Dio(BaseOptions(baseUrl: baseUrl))..httpClientAdapter = adapter;
    final dio = Dio(BaseOptions(baseUrl: baseUrl))..httpClientAdapter = adapter;
    dio.interceptors.add(
      AuthInterceptor(
        readConfig: () => const AppConfig(appToken: 'config-token', clientKey: 'ck'),
        readAccessToken: () => null,
        refreshSession: () async => null,
        replayClient: replay,
        baseUri: Uri.parse(baseUrl),
      ),
    );

    await dio.get<void>('/posts');

    expect(adapter.seenAuthorization.single, 'Bearer config-token');
  });

  test('a request already marked as replayed never triggers another refresh', () async {
    // The other tests in this file cannot exercise `replayedKey`: replays go
    // through `replayClient`, which has no interceptor, so a replayed request
    // never re-enters `onError` and the flag is never read. Delete the flag and
    // they all still pass — verified. This test drives the guard directly, so
    // the second line of defence against an unbounded retry loop is real rather
    // than decorative.
    var refreshes = 0;
    final adapter = _SequencedAdapter(failFirst: 99);
    final replay = Dio(BaseOptions(baseUrl: baseUrl))..httpClientAdapter = adapter;
    final dio = Dio(BaseOptions(baseUrl: baseUrl))..httpClientAdapter = adapter;
    dio.interceptors.add(
      AuthInterceptor(
        readConfig: AppConfig.new,
        readAccessToken: () => 'old-token',
        refreshSession: () async {
          refreshes++;
          return 'new-token';
        },
        replayClient: replay,
        baseUri: Uri.parse(baseUrl),
      ),
    );

    await expectLater(
      dio.get<void>('/posts', options: Options(extra: {AuthInterceptor.replayedKey: true})),
      throwsA(isA<DioException>()),
    );

    expect(refreshes, 0, reason: 'an already-replayed 401 must be surfaced, not refreshed again');
    expect(adapter.calls, 1, reason: 'and it must not be replayed a second time');
  });
}
