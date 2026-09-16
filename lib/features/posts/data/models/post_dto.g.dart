// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PostDto _$PostDtoFromJson(Map<String, dynamic> json) => _PostDto(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  body: json['body'] as String,
  userId: (json['userId'] as num?)?.toInt() ?? 1,
  tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const <String>[],
  createdAt: json['createdAt'] == null ? null : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$PostDtoToJson(_PostDto instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'body': instance.body,
  'userId': instance.userId,
  'tags': instance.tags,
  'createdAt': instance.createdAt?.toIso8601String(),
};
