import 'package:flutter_core_base/core/errors/failure.dart';
import 'package:flutter_core_base/features/posts/data/repositories/posts_repository_impl.dart';
import 'package:flutter_core_base/features/posts/domain/entities/post.dart';
import 'package:flutter_core_base/features/posts/presentation/controllers/posts_state.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'posts_controller.g.dart';

@riverpod
class PostsController extends _$PostsController {
  int _currentPage = 1;
  static const int _pageSize = 10;

  @override
  FutureOr<PostsState> build() async {
    _currentPage = 1;
    final result = await _fetchPosts(page: _currentPage);
    return result.fold(
      (failure) => throw failure,
      (items) => PostsState(items: items, hasMore: items.length == _pageSize),
    );
  }

  Future<Either<Failure, List<Post>>> _fetchPosts({required int page}) async {
    final repository = await ref.read(postsRepositoryProvider.future);
    return repository.getPosts(page: page, limit: _pageSize);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    _currentPage = 1;
    final result = await _fetchPosts(page: _currentPage);
    state = result.fold(
      (failure) => AsyncValue.error(failure, StackTrace.current),
      (items) => AsyncValue.data(PostsState(items: items, hasMore: items.length == _pageSize)),
    );
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || current.isLoadingMore || !current.hasMore || state.isLoading || state.hasError) return;

    state = AsyncValue.data(current.copyWith(isLoadingMore: true, paginationFailure: null));
    final nextPage = _currentPage + 1;
    final result = await _fetchPosts(page: nextPage);
    state = result.fold(
      (failure) => AsyncValue.data(current.copyWith(paginationFailure: failure)),
      (newItems) {
        _currentPage = nextPage;
        return AsyncValue.data(
          current.copyWith(
            items: [...current.items, ...newItems],
            hasMore: newItems.length == _pageSize,
          ),
        );
      },
    );
  }

  Future<Either<Failure, Post>> createPost({required String title, required String body}) async {
    final repository = await ref.read(postsRepositoryProvider.future);
    final result = await repository.createPost(title: title, body: body);

    return result.fold(
      Left.new,
      (newPost) {
        final current = state.value;
        if (current != null) {
          state = AsyncValue.data(current.copyWith(items: [newPost, ...current.items]));
        }
        return Right(newPost);
      },
    );
  }

  Future<Either<Failure, void>> deletePost(int id) async {
    final repository = await ref.read(postsRepositoryProvider.future);
    final result = await repository.deletePost(id);

    return result.fold(
      Left.new,
      (_) {
        final current = state.value;
        if (current != null) {
          state = AsyncValue.data(current.copyWith(items: current.items.where((post) => post.id != id).toList()));
        }
        return const Right(null);
      },
    );
  }
}
