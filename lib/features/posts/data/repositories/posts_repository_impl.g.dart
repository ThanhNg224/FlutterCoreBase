// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'posts_repository_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(postsRepository)
final postsRepositoryProvider = PostsRepositoryProvider._();

final class PostsRepositoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<IPostsRepository>,
          IPostsRepository,
          FutureOr<IPostsRepository>
        >
    with $FutureModifier<IPostsRepository>, $FutureProvider<IPostsRepository> {
  PostsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'postsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$postsRepositoryHash();

  @$internal
  @override
  $FutureProviderElement<IPostsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<IPostsRepository> create(Ref ref) {
    return postsRepository(ref);
  }
}

String _$postsRepositoryHash() => r'2563d7e7f8953b8dc09d30409aeee5df148fced9';
