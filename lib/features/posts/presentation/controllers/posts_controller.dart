import 'package:flutter_core_base/features/posts/data/repositories/posts_repository_impl.dart';
import 'package:flutter_core_base/features/posts/domain/entities/post.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'posts_controller.g.dart';

@riverpod
class PostsController extends _$PostsController {
  int _currentPage = 1;
  static const int _pageSize = 10;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  bool get hasMore => _hasMore;
  bool get isLoadingMore => _isLoadingMore;

  @override
  FutureOr<List<Post>> build() async {
    _currentPage = 1;
    _hasMore = true;
    _isLoadingMore = false;
    return _fetchPosts(page: 1);
  }

  Future<List<Post>> _fetchPosts({required int page}) async {
    final repository = await ref.read(postsRepositoryProvider.future);
    final result = await repository.getPosts(page: page, limit: _pageSize);

    return result.fold(
      (failure) => throw failure,
      (posts) {
        if (posts.length < _pageSize) {
          _hasMore = false;
        }
        return posts;
      },
    );
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      _currentPage = 1;
      _hasMore = true;
      return _fetchPosts(page: 1);
    });
  }

  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasMore || state.isLoading || state.hasError) return;

    final currentPosts = state.value ?? <Post>[];
    _isLoadingMore = true;

    try {
      final nextPage = _currentPage + 1;
      final newPosts = await _fetchPosts(page: nextPage);
      _currentPage = nextPage;
      state = AsyncValue.data([...currentPosts, ...newPosts]);
    } catch (_) {
      // Retain existing items on pagination failure
    } finally {
      _isLoadingMore = false;
    }
  }

  Future<bool> createPost({required String title, required String body}) async {
    final repository = await ref.read(postsRepositoryProvider.future);
    final result = await repository.createPost(title: title, body: body);

    return result.fold(
      (failure) => false,
      (newPost) {
        final currentPosts = state.value ?? <Post>[];
        state = AsyncValue.data([newPost, ...currentPosts]);
        return true;
      },
    );
  }

  Future<bool> deletePost(int id) async {
    final repository = await ref.read(postsRepositoryProvider.future);
    final result = await repository.deletePost(id);

    return result.fold(
      (failure) => false,
      (_) {
        final currentPosts = state.value ?? <Post>[];
        state = AsyncValue.data(currentPosts.where((Post p) => p.id != id).toList());
        return true;
      },
    );
  }
}
