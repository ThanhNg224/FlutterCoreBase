import 'dart:async';

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
  final Map<int, List<Completer<Either<Failure, List<Post>>>>> getPostsCompleters = {};
  Post? postToCreate;
  int lastRequestedPage = 1;

  Completer<Either<Failure, List<Post>>> enqueueGetPosts(int page) {
    final completer = Completer<Either<Failure, List<Post>>>();
    getPostsCompleters.putIfAbsent(page, () => []).add(completer);
    return completer;
  }

  @override
  Future<Either<Failure, List<Post>>> getPosts({int page = 1, int limit = 10}) async {
    lastRequestedPage = page;
    final pending = getPostsCompleters[page];
    if (pending != null && pending.isNotEmpty) {
      final completer = pending.removeAt(0);
      return completer.future;
    }
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
    final newPost = postToCreate ?? Post(id: posts.length + 1, title: title, body: body, userId: userId);
    postToCreate = null;
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

    test('initial build cannot overwrite a newer refresh result', () async {
      final initialBuild = fakeRepository.enqueueGetPosts(1);
      final refresh = fakeRepository.enqueueGetPosts(1);

      final buildFuture = container.read(postsControllerProvider.future);
      final refreshFuture = container.read(postsControllerProvider.notifier).refresh();

      refresh.complete(const Right([Post(id: 42, title: 'Fresh', body: 'Body', userId: 1)]));
      await refreshFuture;

      initialBuild.complete(const Right([Post(id: 1, title: 'Stale', body: 'Body', userId: 1)]));
      await buildFuture;

      final currentState = container.read(postsControllerProvider).value!;
      expect(currentState.items.map((post) => post.id), [42]);
    });

    test('stale initial build preserves a newer refresh error', () async {
      final initialBuild = fakeRepository.enqueueGetPosts(1);
      final refresh = fakeRepository.enqueueGetPosts(1);

      final buildFuture = container.read(postsControllerProvider.future);
      final refreshFuture = container.read(postsControllerProvider.notifier).refresh();

      refresh.complete(const Left(Failure.server(message: 'Refresh failed')));
      await refreshFuture;
      expect(container.read(postsControllerProvider).hasError, isTrue);

      initialBuild.complete(const Right([Post(id: 1, title: 'Stale', body: 'Body', userId: 1)]));
      try {
        await buildFuture;
      } catch (_) {
        // The stale build rethrows the newer refresh error to preserve it.
      }

      final currentState = container.read(postsControllerProvider);
      expect(currentState.hasError, isTrue);
      expect(currentState.error, const Failure.server(message: 'Refresh failed'));
      expect(currentState.stackTrace, isNotNull);
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

    test('refresh preserves existing items and hasValue while network call is in-flight', () async {
      await container.read(postsControllerProvider.future);
      expect(container.read(postsControllerProvider).value?.items, hasLength(2));

      final completer = fakeRepository.enqueueGetPosts(1);

      final refreshFuture = container.read(postsControllerProvider.notifier).refresh();

      // Crucial: while refreshing existing data, state must not become AsyncLoading
      // so AsyncValueWidget.when doesn't unmount the list into a full-screen shimmer/spinner
      final inFlightState = container.read(postsControllerProvider);
      expect(inFlightState.isLoading, isFalse);
      expect(inFlightState.hasValue, isTrue);
      expect(inFlightState.value?.items, hasLength(2));

      completer.complete(const Right([Post(id: 42, title: 'Fresh', body: 'Body', userId: 1)]));
      await refreshFuture;

      final finishedState = container.read(postsControllerProvider).value!;
      expect(finishedState.items, hasLength(1));
      expect(finishedState.items.first.id, 42);
    });

    test('loadMore is ignored while a refresh request is in-flight', () async {
      fakeRepository.posts = List.generate(
        10,
        (index) => Post(id: index + 1, title: 'Post $index', body: 'Body $index', userId: 1),
      );
      await container.read(postsControllerProvider.future);

      final refreshCompleter = fakeRepository.enqueueGetPosts(1);
      final refreshFuture = container.read(postsControllerProvider.notifier).refresh();

      await container.read(postsControllerProvider.notifier).loadMore();
      expect(fakeRepository.lastRequestedPage, 1);

      refreshCompleter.complete(
        Right(List.generate(10, (index) => Post(id: 100 + index, title: 'Fresh $index', body: 'Body', userId: 1))),
      );
      await refreshFuture;
    });

    test('create invalidates an in-flight refresh so it cannot erase the mutation', () async {
      await container.read(postsControllerProvider.future);
      final refreshCompleter = fakeRepository.enqueueGetPosts(1);
      final refreshFuture = container.read(postsControllerProvider.notifier).refresh();

      const createdPost = Post(id: 77, title: 'Created', body: 'Body', userId: 1);
      fakeRepository.postToCreate = createdPost;
      await container.read(postsControllerProvider.notifier).createPost(title: 'Created', body: 'Body');

      refreshCompleter.complete(const Right([Post(id: 1, title: 'Stale refresh', body: 'Body', userId: 1)]));
      await refreshFuture;

      final currentItems = container.read(postsControllerProvider).value!.items;
      expect(currentItems.map((post) => post.id), [createdPost.id, 1, 2]);
      expect(currentItems.first.id, createdPost.id);
    });

    test('create deduplicates a post already returned by refresh', () async {
      await container.read(postsControllerProvider.future);
      final refreshCompleter = fakeRepository.enqueueGetPosts(1);
      final refreshFuture = container.read(postsControllerProvider.notifier).refresh();
      refreshCompleter.complete(
        const Right([
          Post(id: 77, title: 'From refresh', body: 'Body', userId: 1),
          Post(id: 1, title: 'Post 1', body: 'Body 1', userId: 1),
        ]),
      );
      await refreshFuture;

      fakeRepository.postToCreate = const Post(id: 77, title: 'Created', body: 'Body', userId: 1);
      await container.read(postsControllerProvider.notifier).createPost(title: 'Created', body: 'Body');

      final currentItems = container.read(postsControllerProvider).value!.items;
      expect(currentItems.where((post) => post.id == 77), hasLength(1));
    });

    test('delete invalidates an in-flight refresh so a deleted post cannot return', () async {
      fakeRepository.posts = List.generate(
        10,
        (index) => Post(id: index + 1, title: 'Post $index', body: 'Body $index', userId: 1),
      );
      await container.read(postsControllerProvider.future);
      final refreshCompleter = fakeRepository.enqueueGetPosts(1);
      final refreshFuture = container.read(postsControllerProvider.notifier).refresh();

      await container.read(postsControllerProvider.notifier).deletePost(1);
      refreshCompleter.complete(
        Right([
          const Post(id: 1, title: 'Deleted', body: 'Body', userId: 1),
          const Post(id: 99, title: 'Refresh result', body: 'Body', userId: 1),
        ]),
      );
      await refreshFuture;

      final currentItems = container.read(postsControllerProvider).value!.items;
      expect(currentItems.any((post) => post.id == 1), isFalse);
      expect(currentItems.any((post) => post.id == 99), isFalse);
      expect(currentItems, hasLength(9));
    });

    test('loadMore completing after refresh is discarded to prevent overwriting fresh data', () async {
      fakeRepository.posts = List.generate(
        10,
        (index) => Post(id: index + 1, title: 'Post $index', body: 'Body $index', userId: 1),
      );
      await container.read(postsControllerProvider.future);

      final loadMoreCompleter = Completer<Either<Failure, List<Post>>>();
      fakeRepository.getPostsCompleters[2] = [loadMoreCompleter];

      final loadMoreFuture = container.read(postsControllerProvider.notifier).loadMore();

      // Trigger refresh while loadMore is awaiting
      fakeRepository.posts = [
        const Post(id: 999, title: 'Brand New Feed', body: 'After Refresh', userId: 1),
      ];
      await container.read(postsControllerProvider.notifier).refresh();

      expect(container.read(postsControllerProvider).value?.items.map((p) => p.id), [999]);

      // Complete the stale loadMore request
      loadMoreCompleter.complete(
        const Right([Post(id: 200, title: 'Stale page 2', body: 'Should be dropped', userId: 1)]),
      );
      await loadMoreFuture;

      // State must still hold the refreshed items, not overwritten by stale loadMore
      final currentState = container.read(postsControllerProvider).value!;
      expect(currentState.items.map((p) => p.id), [999]);
    });

    test('loadMore preserves posts created during in-flight fetch', () async {
      fakeRepository.posts = List.generate(
        10,
        (index) => Post(id: index + 1, title: 'Post $index', body: 'Body $index', userId: 1),
      );
      await container.read(postsControllerProvider.future);

      final loadMoreCompleter = Completer<Either<Failure, List<Post>>>();
      fakeRepository.getPostsCompleters[2] = [loadMoreCompleter];

      final loadMoreFuture = container.read(postsControllerProvider.notifier).loadMore();

      // Create a post during loadMore
      await container.read(postsControllerProvider.notifier).createPost(title: 'Created Post', body: 'Body');

      expect(container.read(postsControllerProvider).value?.items.first.title, 'Created Post');

      // Complete loadMore
      loadMoreCompleter.complete(
        const Right([Post(id: 201, title: 'Page 2 Post', body: 'Body', userId: 1)]),
      );
      await loadMoreFuture;

      final currentState = container.read(postsControllerProvider).value!;
      expect(currentState.items.any((p) => p.title == 'Created Post'), isTrue);
      expect(currentState.items.any((p) => p.id == 201), isFalse);
      expect(currentState.isLoadingMore, isFalse);

      final retryCompleter = fakeRepository.enqueueGetPosts(2);
      final retryFuture = container.read(postsControllerProvider.notifier).loadMore();
      expect(fakeRepository.lastRequestedPage, 2);
      retryCompleter.complete(const Right([Post(id: 201, title: 'Page 2 Post', body: 'Body', userId: 1)]));
      await retryFuture;

      final retriedState = container.read(postsControllerProvider).value!;
      expect(retriedState.items.any((p) => p.id == 201), isTrue);
    });

    test('loadMore does not restore posts deleted during in-flight fetch', () async {
      fakeRepository.posts = List.generate(
        10,
        (index) => Post(id: index + 1, title: 'Post $index', body: 'Body $index', userId: 1),
      );
      await container.read(postsControllerProvider.future);

      final loadMoreCompleter = Completer<Either<Failure, List<Post>>>();
      fakeRepository.getPostsCompleters[2] = [loadMoreCompleter];

      final loadMoreFuture = container.read(postsControllerProvider.notifier).loadMore();

      // Delete post 1 during loadMore
      await container.read(postsControllerProvider.notifier).deletePost(1);

      expect(container.read(postsControllerProvider).value?.items.any((p) => p.id == 1), isFalse);

      // Complete loadMore
      loadMoreCompleter.complete(
        const Right([
          Post(id: 1, title: 'Deleted from page 2', body: 'Body', userId: 1),
          Post(id: 202, title: 'Page 2 Post', body: 'Body', userId: 1),
        ]),
      );
      await loadMoreFuture;

      final currentState = container.read(postsControllerProvider).value!;
      expect(currentState.items.any((p) => p.id == 1), isFalse);
      expect(currentState.items.any((p) => p.id == 202), isFalse);
      expect(currentState.isLoadingMore, isFalse);

      final retryCompleter = fakeRepository.enqueueGetPosts(2);
      final retryFuture = container.read(postsControllerProvider.notifier).loadMore();
      expect(fakeRepository.lastRequestedPage, 2);
      retryCompleter.complete(const Right([Post(id: 202, title: 'Page 2 Post', body: 'Body', userId: 1)]));
      await retryFuture;

      final retriedState = container.read(postsControllerProvider).value!;
      expect(retriedState.items.any((p) => p.id == 202), isTrue);
    });

    test('loadMore advances by requested page when a full page contains duplicates', () async {
      fakeRepository.posts = List.generate(
        10,
        (index) => Post(id: index + 1, title: 'Post $index', body: 'Body $index', userId: 1),
      );
      await container.read(postsControllerProvider.future);

      final pageTwoCompleter = fakeRepository.enqueueGetPosts(2);
      final pageTwoFuture = container.read(postsControllerProvider.notifier).loadMore();
      pageTwoCompleter.complete(
        Right([
          const Post(id: 1, title: 'Duplicate 1', body: 'Body', userId: 1),
          const Post(id: 2, title: 'Duplicate 2', body: 'Body', userId: 1),
          ...List.generate(
            8,
            (index) => Post(id: 100 + index, title: 'New $index', body: 'Body', userId: 1),
          ),
        ]),
      );
      await pageTwoFuture;

      final pageThreeCompleter = fakeRepository.enqueueGetPosts(3);
      final pageThreeFuture = container.read(postsControllerProvider.notifier).loadMore();
      pageThreeCompleter.complete(const Right([]));
      await pageThreeFuture;

      expect(fakeRepository.lastRequestedPage, 3);
    });

    test('create after a terminal short page keeps pagination closed', () async {
      fakeRepository.posts = List.generate(
        9,
        (index) => Post(id: index + 1, title: 'Post $index', body: 'Body $index', userId: 1),
      );
      await container.read(postsControllerProvider.future);
      expect(container.read(postsControllerProvider).value!.hasMore, isFalse);

      fakeRepository.postToCreate = const Post(id: 99, title: 'Created', body: 'Body', userId: 1);
      await container.read(postsControllerProvider.notifier).createPost(title: 'Created', body: 'Body');

      final currentState = container.read(postsControllerProvider).value!;
      expect(currentState.items, hasLength(10));
      expect(currentState.hasMore, isFalse);
    });

    test('pagination page adapts after create and delete', () async {
      fakeRepository.posts = List.generate(
        10,
        (index) => Post(id: index + 1, title: 'Post $index', body: 'Body $index', userId: 1),
      );
      await container.read(postsControllerProvider.future);
      expect(fakeRepository.lastRequestedPage, 1);

      // Create 10 posts so we now have 20 items (2 full pages)
      for (int i = 0; i < 10; i++) {
        await container.read(postsControllerProvider.notifier).createPost(title: 'Extra $i', body: 'Body');
      }

      fakeRepository.posts = List.generate(
        10,
        (index) => Post(id: 300 + index, title: 'Page 3 item $index', body: 'Body', userId: 1),
      );

      await container.read(postsControllerProvider.notifier).loadMore();
      // Should have requested page 3 (because 20 items = 2 full pages)
      expect(fakeRepository.lastRequestedPage, 3);

      // Now delete 15 posts (leaving 6 items in memory)
      final state = container.read(postsControllerProvider).value!;
      final idsToDelete = state.items.take(15).map((p) => p.id).toList();
      for (final id in idsToDelete) {
        await container.read(postsControllerProvider.notifier).deletePost(id);
      }

      fakeRepository.posts = [
        const Post(id: 400, title: 'Page 2 item', body: 'Body', userId: 1),
      ];
      await container.read(postsControllerProvider.notifier).loadMore();
      // With 6 items left, pagination should adapt back to requesting page 2 rather than page 4
      expect(fakeRepository.lastRequestedPage, 2);
    });
  });
}
