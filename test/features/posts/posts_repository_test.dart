import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_core_base/features/posts/data/datasources/posts_remote_datasource.dart';
import 'package:flutter_core_base/features/posts/data/models/post_dto.dart';
import 'package:flutter_core_base/features/posts/data/repositories/posts_repository_impl.dart';

class MockPostsRemoteDataSource implements IPostsRemoteDataSource {
  @override
  Future<List<PostDto>> getPosts({int page = 1, int limit = 10}) async {
    return [
      const PostDto(id: 1, title: 'Test Title 1', body: 'Test Body 1', userId: 1),
      const PostDto(id: 2, title: 'Test Title 2', body: 'Test Body 2', userId: 2),
    ];
  }

  @override
  Future<PostDto> getPostDetail(int id) async {
    return PostDto(id: id, title: 'Detail Title $id', body: 'Detail Body $id', userId: 1);
  }

  @override
  Future<PostDto> createPost({required String title, required String body, int userId = 1}) async {
    return PostDto(id: 99, title: title, body: body, userId: userId);
  }

  @override
  Future<void> deletePost(int id) async {}
}

void main() {
  late MockPostsRemoteDataSource mockDataSource;
  late PostsRepositoryImpl repository;

  setUp(() {
    mockDataSource = MockPostsRemoteDataSource();
    repository = PostsRepositoryImpl(remoteDataSource: mockDataSource);
  });

  group('PostsRepositoryImpl', () {
    test('getPosts returns mapped domain Post entities on success', () async {
      final result = await repository.getPosts();

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Should be Right'),
        (posts) {
          expect(posts.length, 2);
          expect(posts.first.id, 1);
          expect(posts.first.title, 'Test Title 1');
          expect(posts.first.tags, contains('General'));
        },
      );
    });

    test('getPostDetail returns single Post entity on success', () async {
      final result = await repository.getPostDetail(42);

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Should be Right'),
        (post) {
          expect(post.id, 42);
          expect(post.title, 'Detail Title 42');
        },
      );
    });

    test('createPost returns new Post entity on success', () async {
      final result = await repository.createPost(title: 'New Title', body: 'New Body');

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Should be Right'),
        (post) {
          expect(post.id, 99);
          expect(post.title, 'New Title');
          expect(post.body, 'New Body');
        },
      );
    });

    test('deletePost completes successfully', () async {
      final result = await repository.deletePost(1);

      expect(result.isRight(), isTrue);
    });
  });
}
