import 'dart:math';

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
  int _stateGeneration = 0;
  int _paginationGeneration = 0;
  int _refreshInFlightCount = 0;
  final Set<int> _deletedPostIds = <int>{};
  static const int _pageSize = 10;

  @override
  FutureOr<PostsState> build() async {
    final generation = ++_stateGeneration;
    ++_paginationGeneration;
    _currentPage = 1;
    final result = await _fetchPosts(page: _currentPage);
    if (generation != _stateGeneration) {
      final currentState = state;
      if (currentState.hasError) {
        Error.throwWithStackTrace(currentState.error!, currentState.stackTrace!);
      }
      return currentState.value ?? const PostsState();
    }

    return result.fold(
      (failure) => throw failure,
      (items) {
        _deletedPostIds.clear();
        _currentPage = max(1, items.length ~/ _pageSize);
        return PostsState(items: items, hasMore: items.length == _pageSize);
      },
    );
  }

  Future<Either<Failure, List<Post>>> _fetchPosts({required int page}) async {
    final repository = await ref.read(postsRepositoryProvider.future);
    return repository.getPosts(page: page, limit: _pageSize);
  }

  Future<void> refresh() async {
    final generation = ++_stateGeneration;
    ++_paginationGeneration;
    ++_refreshInFlightCount;
    try {
      if (!state.hasValue) {
        state = const AsyncValue.loading();
      }
      _currentPage = 1;
      final result = await _fetchPosts(page: _currentPage);
      if (generation != _stateGeneration) return;

      state = result.fold(
        (failure) => AsyncValue.error(failure, StackTrace.current),
        (items) {
          _deletedPostIds.clear();
          _currentPage = max(1, items.length ~/ _pageSize);
          return AsyncValue.data(PostsState(items: items, hasMore: items.length == _pageSize));
        },
      );
    } finally {
      --_refreshInFlightCount;
    }
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null ||
        current.isLoadingMore ||
        !current.hasMore ||
        state.isLoading ||
        state.hasError ||
        _refreshInFlightCount > 0) {
      return;
    }

    final generation = _paginationGeneration;
    state = AsyncValue.data(current.copyWith(isLoadingMore: true, paginationFailure: null));
    final nextPage = _currentPage + 1;
    final result = await _fetchPosts(page: nextPage);

    if (generation != _paginationGeneration) return;

    final latest = state.value;
    if (latest == null) return;

    state = result.fold(
      (failure) => AsyncValue.data(
        latest.copyWith(
          isLoadingMore: false,
          paginationFailure: failure,
        ),
      ),
      (newItems) {
        final existingIds = latest.items.map((p) => p.id).toSet();
        final uniqueNewItems = newItems
            .where((p) => !existingIds.contains(p.id) && !_deletedPostIds.contains(p.id))
            .toList();
        final updatedItems = [...latest.items, ...uniqueNewItems];
        _currentPage = nextPage;
        return AsyncValue.data(
          latest.copyWith(
            isLoadingMore: false,
            items: updatedItems,
            hasMore: newItems.length == _pageSize,
            paginationFailure: null,
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
        ++_stateGeneration;
        ++_paginationGeneration;
        _deletedPostIds.remove(newPost.id);
        final current = state.value;
        if (current != null) {
          final updatedItems = [newPost, ...current.items.where((post) => post.id != newPost.id)];
          _currentPage = max(1, updatedItems.length ~/ _pageSize);
          state = AsyncValue.data(
            current.copyWith(
              items: updatedItems,
              isLoadingMore: false,
              paginationFailure: null,
            ),
          );
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
        ++_stateGeneration;
        ++_paginationGeneration;
        _deletedPostIds.add(id);
        final current = state.value;
        if (current != null) {
          final updatedItems = current.items.where((post) => post.id != id).toList();
          _currentPage = max(1, updatedItems.length ~/ _pageSize);
          state = AsyncValue.data(
            current.copyWith(
              items: updatedItems,
              isLoadingMore: false,
              paginationFailure: null,
            ),
          );
        }
        return const Right(null);
      },
    );
  }
}
