import 'dart:convert';
import 'dart:io';

import 'package:flutter_core_base/core/config/app_config.dart';
import 'package:flutter_core_base/core/config/app_config_controller.dart';
import 'package:flutter_core_base/core/storage/secure_storage_service.dart';
import 'package:flutter_core_base/core/storage/storage_providers.dart';
import 'package:flutter_core_base/features/posts/data/repositories/posts_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeSecureStorageService implements ISecureStorageService {
  @override
  Future<void> delete(String key) async {}

  @override
  Future<String?> read(String key) async => null;

  @override
  Future<void> write({required String key, required String value}) async {}
}

class _LocalAppConfigController extends AppConfigController {
  _LocalAppConfigController(this.baseUrl);

  final String baseUrl;

  @override
  Future<AppConfig> build() async => AppConfig(baseUrl: baseUrl);
}

void main() {
  test('posts repository completes a real Dio request after provider read', () async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    addTearDown(server.close);
    server.listen((request) async {
      expect(request.uri.path, '/posts');
      request.response.headers.contentType = ContentType.json;
      request.response.write(
        jsonEncode([
          {'id': 7, 'title': 'Network post', 'body': 'Returned by HttpServer', 'userId': 3},
        ]),
      );
      await request.response.close();
    });

    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(preferences),
        secureStorageServiceProvider.overrideWithValue(_FakeSecureStorageService()),
        appConfigControllerProvider.overrideWith(
          () => _LocalAppConfigController('http://${server.address.address}:${server.port}'),
        ),
      ],
    );
    addTearDown(container.dispose);

    final repository = await container.read(postsRepositoryProvider.future);
    final result = await repository.getPosts();

    result.match(
      (failure) => fail('Expected the local server response, got $failure'),
      (posts) {
        expect(posts, hasLength(1));
        expect(posts.single.id, 7);
        expect(posts.single.title, 'Network post');
      },
    );
  });
}
