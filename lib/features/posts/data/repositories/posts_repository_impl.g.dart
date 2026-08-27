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
        isAutoDispose: true,
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

String _$postsRepositoryHash() => r'0df1f6cf90b4d6e961d693535b090f28f3f1b13b';
