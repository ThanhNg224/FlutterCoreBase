// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'posts_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PostsController)
final postsControllerProvider = PostsControllerProvider._();

final class PostsControllerProvider
    extends $AsyncNotifierProvider<PostsController, List<Post>> {
  PostsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'postsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$postsControllerHash();

  @$internal
  @override
  PostsController create() => PostsController();
}

String _$postsControllerHash() => r'98fd041460f3c236f56ac005fdb244536cd598b9';

abstract class _$PostsController extends $AsyncNotifier<List<Post>> {
  FutureOr<List<Post>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Post>>, List<Post>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Post>>, List<Post>>,
              AsyncValue<List<Post>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
