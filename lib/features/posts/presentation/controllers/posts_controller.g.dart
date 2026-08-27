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
    extends $AsyncNotifierProvider<PostsController, PostsState> {
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

String _$postsControllerHash() => r'eb653c08fa88bb42815c1c6b15508ce8317d77a2';

abstract class _$PostsController extends $AsyncNotifier<PostsState> {
  FutureOr<PostsState> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<PostsState>, PostsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<PostsState>, PostsState>,
              AsyncValue<PostsState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
