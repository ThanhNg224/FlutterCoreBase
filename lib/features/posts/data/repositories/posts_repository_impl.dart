import 'package:fpdart/fpdart.dart';
import 'package:flutter_core_base/core/errors/error_handler.dart';
import 'package:flutter_core_base/core/errors/failure.dart';
import 'package:flutter_core_base/features/posts/data/datasources/posts_remote_datasource.dart';
import 'package:flutter_core_base/features/posts/domain/entities/post.dart';
import 'package:flutter_core_base/features/posts/domain/repositories/i_posts_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'posts_repository_impl.g.dart';

class PostsRepositoryImpl implements IPostsRepository {
  final IPostsRemoteDataSource remoteDataSource;

  const PostsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Post>>> getPosts({int page = 1, int limit = 10}) {
    return ErrorHandler.guard(() async {
      final dtos = await remoteDataSource.getPosts(page: page, limit: limit);
      return dtos.map((dto) => dto.toDomain()).toList();
    });
  }

  @override
  Future<Either<Failure, Post>> getPostDetail(int id) {
    return ErrorHandler.guard(() async {
      final dto = await remoteDataSource.getPostDetail(id);
      return dto.toDomain();
    });
  }

  @override
  Future<Either<Failure, Post>> createPost({required String title, required String body, int userId = 1}) {
    return ErrorHandler.guard(() async {
      final dto = await remoteDataSource.createPost(title: title, body: body, userId: userId);
      return dto.toDomain();
    });
  }

  @override
  Future<Either<Failure, void>> deletePost(int id) {
    return ErrorHandler.guard(() async {
      await remoteDataSource.deletePost(id);
    });
  }
}

@Riverpod(keepAlive: true)
IPostsRepository postsRepository(Ref ref) {
  final remoteDataSource = ref.watch(postsRemoteDataSourceProvider);
  return PostsRepositoryImpl(remoteDataSource: remoteDataSource);
}
