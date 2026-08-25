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
          IPostsRepository,
          IPostsRepository,
          IPostsRepository
        >
    with $Provider<IPostsRepository> {
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
  $ProviderElement<IPostsRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  IPostsRepository create(Ref ref) {
    return postsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IPostsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IPostsRepository>(value),
    );
  }
}

String _$postsRepositoryHash() => r'1a37292399f8416d540760bd20d6431d92faad5d';
