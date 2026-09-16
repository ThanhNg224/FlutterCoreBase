import 'package:freezed_annotation/freezed_annotation.dart';

part 'post.freezed.dart';

/// Domain entity. Deliberately has no `fromJson`: wire parsing belongs to
/// [PostDto] in the data layer, and giving the entity a JSON constructor is
/// how a codebase quietly loses its DTO boundary.
@freezed
abstract class Post with _$Post {
  const factory Post({
    required int id,
    required String title,
    required String body,
    @Default(1) int userId,
    @Default(<String>[]) List<String> tags,
    DateTime? createdAt,
  }) = _Post;
}
