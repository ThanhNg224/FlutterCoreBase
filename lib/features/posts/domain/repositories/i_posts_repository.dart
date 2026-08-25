import 'package:fpdart/fpdart.dart';
import 'package:flutter_core_base/core/errors/failure.dart';
import 'package:flutter_core_base/features/posts/domain/entities/post.dart';

abstract interface class IPostsRepository {
  Future<Either<Failure, List<Post>>> getPosts({int page = 1, int limit = 10});
  Future<Either<Failure, Post>> getPostDetail(int id);
  Future<Either<Failure, Post>> createPost({required String title, required String body, int userId = 1});
  Future<Either<Failure, void>> deletePost(int id);
}
