import 'package:flutter_core_base/core/errors/failure.dart';
import 'package:flutter_core_base/core/pagination/paginator.dart';
import 'package:flutter_core_base/features/posts/data/repositories/posts_repository_impl.dart';
import 'package:flutter_core_base/features/posts/domain/entities/post.dart';
import 'package:flutter_core_base/features/posts/presentation/controllers/posts_state.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'posts_controller.g.dart';

@riverpod
class PostsController extends _$PostsController {
  static const int _pageSize = 10;

  final Paginator<Post, int> _paginator = Paginator<Post, int>(
    pageSize: _pageSize,
    idOf: (post) => post.id,
  );

  @override
  FutureOr<PostsState> build() async {
    final token = _paginator.beginReload();
    final result = await _fetchPosts(page: 1);

    if (_paginator.isReloadStale(token)) {
      final currentState = state;
      if (currentState.hasError) {
        Error.throwWithStackTrace(currentState.error!, currentState.stackTrace!);
      }
      return currentState.value ?? const PostsState();
    }

    return result.fold(
      (failure) => throw failure,
      _paginator.onFirstPage,
    );
  }

  Future<Either<Failure, List<Post>>> _fetchPosts({required int page}) async {
    final repository = await ref.read(postsRepositoryProvider.future);
    return repository.getPosts(page: page, limit: _pageSize);
  }

  Future<void> refresh() async {
    final token = _paginator.beginReload(tracksInFlight: true);
    try {
      if (!state.hasValue) {
        state = const AsyncValue.loading();
      }
      final result = await _fetchPosts(page: 1);
      if (_paginator.isReloadStale(token)) return;

      state = result.fold(
        (failure) => AsyncValue.error(failure, StackTrace.current),
        (items) => AsyncValue.data(_paginator.onFirstPage(items)),
      );
    } finally {
      _paginator.endReload();
    }
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (!_paginator.canLoadMore(current, isLoading: state.isLoading, hasError: state.hasError)) {
      return;
    }

    final token = _paginator.pageToken;
    final nextPage = _paginator.nextPage;
    state = AsyncValue.data(current!.copyWith(isLoadingMore: true, paginationFailure: null));

    final result = await _fetchPosts(page: nextPage);
    if (_paginator.isPageStale(token)) return;

    final latest = state.value;
    if (latest == null) return;

    state = result.fold(
      (failure) => AsyncValue.data(latest.copyWith(isLoadingMore: false, paginationFailure: failure)),
      (newItems) => AsyncValue.data(_paginator.onNextPage(latest, newItems, page: nextPage)),
    );
  }

  Future<Either<Failure, Post>> createPost({required String title, required String body}) async {
    final repository = await ref.read(postsRepositoryProvider.future);
    final result = await repository.createPost(title: title, body: body);

    return result.fold(
      Left.new,
      (newPost) {
        final next = _paginator.onItemInserted(state.value, newPost);
        if (next != null) state = AsyncValue.data(next);
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
        final next = _paginator.onItemRemoved(state.value, id);
        if (next != null) state = AsyncValue.data(next);
        return const Right(null);
      },
    );
  }
}
