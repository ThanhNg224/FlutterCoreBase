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
  int _generation = 0;
  static const int _pageSize = 10;

  @override
  FutureOr<PostsState> build() async {
    _generation++;
    _currentPage = 1;
    final result = await _fetchPosts(page: _currentPage);
    return result.fold(
      (failure) => throw failure,
      (items) {
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
    final generation = ++_generation;
    if (!state.hasValue) {
      state = const AsyncValue.loading();
    }
    _currentPage = 1;
    final result = await _fetchPosts(page: _currentPage);
    if (generation != _generation) return;

    state = result.fold(
      (failure) => AsyncValue.error(failure, StackTrace.current),
      (items) {
        _currentPage = max(1, items.length ~/ _pageSize);
        return AsyncValue.data(PostsState(items: items, hasMore: items.length == _pageSize));
      },
    );
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || current.isLoadingMore || !current.hasMore || state.isLoading || state.hasError) return;

    final generation = _generation;
    state = AsyncValue.data(current.copyWith(isLoadingMore: true, paginationFailure: null));
    final nextPage = max(1, current.items.length ~/ _pageSize) + 1;
    final result = await _fetchPosts(page: nextPage);

    if (generation != _generation) return;

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
        final uniqueNewItems = newItems.where((p) => !existingIds.contains(p.id)).toList();
        final updatedItems = [...latest.items, ...uniqueNewItems];
        _currentPage = max(1, updatedItems.length ~/ _pageSize);
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
        final current = state.value;
        if (current != null) {
          final updatedItems = [newPost, ...current.items];
          _currentPage = max(1, updatedItems.length ~/ _pageSize);
          state = AsyncValue.data(current.copyWith(items: updatedItems));
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
          final updatedItems = current.items.where((post) => post.id != id).toList();
          _currentPage = max(1, updatedItems.length ~/ _pageSize);
          state = AsyncValue.data(current.copyWith(items: updatedItems));
        }
        return const Right(null);
      },
    );
  }
}
