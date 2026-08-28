import 'package:dio/dio.dart';
import 'package:flutter_core_base/core/config/app_config_controller.dart';
import 'package:flutter_core_base/core/constants/api_endpoints.dart';
import 'package:flutter_core_base/core/network/dio_client.dart';
import 'package:flutter_core_base/features/posts/data/models/post_dto.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'posts_remote_datasource.g.dart';

abstract interface class IPostsRemoteDataSource {
  Future<List<PostDto>> getPosts({int page = 1, int limit = 10});
  Future<PostDto> getPostDetail(int id);
  Future<PostDto> createPost({required String title, required String body, int userId = 1});
  Future<void> deletePost(int id);
}

class PostsRemoteDataSource implements IPostsRemoteDataSource {
  final Dio dio;
  final bool isMock;

  const PostsRemoteDataSource({
    required this.dio,
    this.isMock = false,
  });

  @override
  Future<List<PostDto>> getPosts({int page = 1, int limit = 10}) async {
    if (isMock) {
      await Future<void>.delayed(const Duration(milliseconds: 300));
      return List.generate(
        limit,
        (i) => PostDto(
          id: (page - 1) * limit + i + 1,
          title: 'Sample Article #${(page - 1) * limit + i + 1}: Clean Architecture & Riverpod',
          body: 'This is a sample article demonstrating how Riverpod AsyncNotifier and Clean Architecture seamlessly manage remote data with error handling.',
          userId: ((i % 3) + 1),
        ),
      );
    }

    final response = await dio.get<List<dynamic>>(
      ApiEndpoints.posts,
      queryParameters: {'_page': page, '_limit': limit},
    );

    final rawList = response.data ?? [];
    return rawList.map((e) => PostDto.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<PostDto> getPostDetail(int id) async {
    if (isMock) {
      await Future<void>.delayed(const Duration(milliseconds: 200));
      return PostDto(
        id: id,
        title: 'Sample Article #$id: Deep Dive into Architecture',
        body: 'Detailed breakdown of Flutter Riverpod Generator, immutable Freezed models, and GoRouter declarative routing patterns.',
        userId: 1,
      );
    }

    final response = await dio.get<Map<String, dynamic>>('${ApiEndpoints.posts}/$id');
    return PostDto.fromJson(response.data!);
  }

  @override
  Future<PostDto> createPost({required String title, required String body, int userId = 1}) async {
    if (isMock) {
      await Future<void>.delayed(const Duration(milliseconds: 300));
      return PostDto(
        id: DateTime.now().millisecondsSinceEpoch % 10000,
        title: title,
        body: body,
        userId: userId,
      );
    }

    final response = await dio.post<Map<String, dynamic>>(
      ApiEndpoints.posts,
      data: {'title': title, 'body': body, 'userId': userId},
    );
    return PostDto.fromJson(response.data!);
  }

  @override
  Future<void> deletePost(int id) async {
    if (isMock) {
      await Future<void>.delayed(const Duration(milliseconds: 200));
      return;
    }
    await dio.delete<dynamic>('${ApiEndpoints.posts}/$id');
  }
}

@Riverpod(keepAlive: true)
Future<IPostsRemoteDataSource> postsRemoteDataSource(Ref ref) async {
  final dio = await ref.watch(dioClientProvider.future);
  final config = await ref.watch(appConfigControllerProvider.future);
  return PostsRemoteDataSource(dio: dio, isMock: config.mockSdkEnabled);
}
