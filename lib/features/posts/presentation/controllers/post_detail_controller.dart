import 'package:flutter_core_base/features/posts/data/repositories/posts_repository_impl.dart';
import 'package:flutter_core_base/features/posts/domain/entities/post.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_detail_controller.g.dart';

@riverpod
class PostDetailController extends _$PostDetailController {
  @override
  FutureOr<Post> build(int id) async {
    final repository = await ref.read(postsRepositoryProvider.future);
    final result = await repository.getPostDetail(id);

    return result.fold(
      (failure) => throw failure,
      (post) => post,
    );
  }
}
