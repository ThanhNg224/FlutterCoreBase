import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_core_base/core/errors/failure.dart';
import 'package:flutter_core_base/features/posts/data/repositories/posts_repository_impl.dart';
import 'package:flutter_core_base/features/posts/domain/entities/post.dart';
import 'package:flutter_core_base/features/posts/domain/repositories/i_posts_repository.dart';
import 'package:flutter_core_base/features/posts/presentation/controllers/posts_controller.dart';
import 'package:flutter_core_base/features/posts/presentation/controllers/posts_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FakePostsRepository implements IPostsRepository {
  List<Post> posts = [
    const Post(id: 1, title: 'Post 1', body: 'Body 1', userId: 1),
    const Post(id: 2, title: 'Post 2', body: 'Body 2', userId: 1),
  ];

  bool shouldFail = false;
  bool shouldFailLoadMore = false;

  @override
  Future<Either<Failure, List<Post>>> getPosts({int page = 1, int limit = 10}) async {
    if (shouldFail || (shouldFailLoadMore && page > 1)) {
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
      final state = await container.read(postsControllerProvider.future);

      expect(state.items.length, 2);
      expect(state.items[0].id, 1);
    });

    test('createPost adds new post to the top of the list', () async {
      await container.read(postsControllerProvider.future);

      final result = await container
          .read(postsControllerProvider.notifier)
          .createPost(title: 'Brand New', body: 'Content');

      expect(result.isRight(), isTrue);
      final currentState = container.read(postsControllerProvider).value!;
      expect(currentState.items.length, 3);
      expect(currentState.items.first.title, 'Brand New');
    });

    test('deletePost removes post from the list', () async {
      await container.read(postsControllerProvider.future);

      final result = await container.read(postsControllerProvider.notifier).deletePost(1);

      expect(result.isRight(), isTrue);
      final currentState = container.read(postsControllerProvider).value!;
      expect(currentState.items.length, 1);
      expect(currentState.items.any((p) => p.id == 1), isFalse);
    });

    test('refresh reloads list', () async {
      await container.read(postsControllerProvider.future);

      fakeRepository.posts = [
        const Post(id: 100, title: 'Refreshed Post', body: 'Refreshed Content', userId: 1),
      ];

      await container.read(postsControllerProvider.notifier).refresh();

      final currentState = container.read(postsControllerProvider).value!;
      expect(currentState.items.length, 1);
      expect(currentState.items.first.id, 100);
    });

    test('retains posts and exposes a pagination failure', () async {
      fakeRepository.posts = List.generate(
        10,
        (index) => Post(id: index + 1, title: 'Post $index', body: 'Body $index', userId: 1),
      );
      await container.read(postsControllerProvider.future);
      fakeRepository.shouldFailLoadMore = true;

      await container.read(postsControllerProvider.notifier).loadMore();

      final currentState = container.read(postsControllerProvider).value!;
      expect(currentState, isA<PostsState>());
      expect(currentState.items, hasLength(10));
      expect(currentState.isLoadingMore, isFalse);
      expect(currentState.paginationFailure, const Failure.server(message: 'Server down'));
    });
  });
}
