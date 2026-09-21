import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_core_base/features/posts/domain/entities/post.dart';

part 'post_dto.freezed.dart';
part 'post_dto.g.dart';

@freezed
abstract class PostDto with _$PostDto {
  const factory PostDto({
    required int id,
    required String title,
    required String body,
    @JsonKey(name: 'userId') @Default(1) int userId,
    @Default(<String>[]) List<String> tags,
    DateTime? createdAt,
  }) = _PostDto;

  const PostDto._();

  factory PostDto.fromJson(Map<String, dynamic> json) => _$PostDtoFromJson(json);

  /// Field-for-field copy. A mapper translates shapes; it never invents values.
  /// Sample data belongs in the data source's mock branch, not here.
  Post toDomain() => Post(
    id: id,
    title: title,
    body: body,
    userId: userId,
    tags: tags,
    createdAt: createdAt,
  );
}
