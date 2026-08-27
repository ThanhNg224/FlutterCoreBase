import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_core_base/core/errors/failure.dart';
import 'package:flutter_core_base/features/posts/data/repositories/posts_repository_impl.dart';
import 'package:flutter_core_base/features/posts/domain/entities/post.dart';
import 'package:flutter_core_base/features/posts/domain/repositories/i_posts_repository.dart';
import 'package:flutter_core_base/features/posts/presentation/controllers/posts_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FakePostsRepository implements IPostsRepository {
  List<Post> posts = [
    const Post(id: 1, title: 'Post 1', body: 'Body 1', userId: 1),
    const Post(id: 2, title: 'Post 2', body: 'Body 2', userId: 1),
  ];

  bool shouldFail = false;

  @override
  Future<Either<Failure, List<Post>>> getPosts({int page = 1, int limit = 10}) async {
    if (shouldFail) {
      return const Left(Failure.server(message: 'Server down'));
    }
    return Right(List.of(posts));
  }

  @override
  Future<Either<Failure, Post>> getPostDetail(int id) async {
    final post = posts.firstWhere((p) => p.id == id);
    return Right(post);
  }

  @override
  Future<Either<Failure, Post>> createPost({required String title, required String body, int userId = 1}) async {
    final newPost = Post(id: posts.length + 1, title: title, body: body, userId: userId);
    posts.insert(0, newPost);
    return Right(newPost);
  }

  @override
  Future<Either<Failure, void>> deletePost(int id) async {
    posts.removeWhere((p) => p.id == id);
    return const Right(null);
  }
}

void main() {
  late FakePostsRepository fakeRepository;
  late ProviderContainer container;

  setUp(() {
    fakeRepository = FakePostsRepository();
    container = ProviderContainer(
      overrides: [
        postsRepositoryProvider.overrideWith((ref) async => fakeRepository as IPostsRepository),
      ],
    );
  });

  tearDown(() => container.dispose());

  group('PostsController', () {
    test('initial build fetches posts successfully', () async {
      final posts = await container.read(postsControllerProvider.future);

      expect(posts.length, 2);
      expect(posts[0].id, 1);
    });

    test('createPost adds new post to the top of the list', () async {
      await container.read(postsControllerProvider.future);

      final success = await container
          .read(postsControllerProvider.notifier)
          .createPost(title: 'Brand New', body: 'Content');

      expect(success, isTrue);
      final currentList = container.read(postsControllerProvider).value!;
      expect(currentList.length, 3);
      expect(currentList.first.title, 'Brand New');
    });

    test('deletePost removes post from the list', () async {
      await container.read(postsControllerProvider.future);

      final success = await container.read(postsControllerProvider.notifier).deletePost(1);

      expect(success, isTrue);
      final currentList = container.read(postsControllerProvider).value!;
      expect(currentList.length, 1);
      expect(currentList.any((p) => p.id == 1), isFalse);
    });

    test('refresh reloads list', () async {
      await container.read(postsControllerProvider.future);

      fakeRepository.posts = [
        const Post(id: 100, title: 'Refreshed Post', body: 'Refreshed Content', userId: 1),
      ];

      await container.read(postsControllerProvider.notifier).refresh();

      final currentList = container.read(postsControllerProvider).value!;
      expect(currentList.length, 1);
      expect(currentList.first.id, 100);
    });
  });
}
