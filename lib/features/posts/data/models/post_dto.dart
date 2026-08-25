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
  }) = _PostDto;

  const PostDto._();

  factory PostDto.fromJson(Map<String, dynamic> json) => _$PostDtoFromJson(json);

  Post toDomain() {
    return Post(
      id: id,
      title: title,
      body: body,
      userId: userId,
      tags: ['General', 'Article', 'User #$userId'],
      createdAt: DateTime.now().subtract(Duration(hours: id * 3)),
    );
  }
}
