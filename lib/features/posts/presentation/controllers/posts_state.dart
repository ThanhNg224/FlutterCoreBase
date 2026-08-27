import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_core_base/core/errors/failure.dart';
import 'package:flutter_core_base/features/posts/domain/entities/post.dart';

part 'posts_state.freezed.dart';

@freezed
abstract class PostsState with _$PostsState {
  const factory PostsState({
    @Default(<Post>[]) List<Post> items,
    @Default(true) bool hasMore,
    @Default(false) bool isLoadingMore,
    Failure? paginationFailure,
  }) = _PostsState;
}
