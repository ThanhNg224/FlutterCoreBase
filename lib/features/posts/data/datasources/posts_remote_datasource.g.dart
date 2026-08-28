// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'posts_remote_datasource.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(postsRemoteDataSource)
final postsRemoteDataSourceProvider = PostsRemoteDataSourceProvider._();

final class PostsRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          AsyncValue<IPostsRemoteDataSource>,
          IPostsRemoteDataSource,
          FutureOr<IPostsRemoteDataSource>
        >
    with
        $FutureModifier<IPostsRemoteDataSource>,
        $FutureProvider<IPostsRemoteDataSource> {
  PostsRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'postsRemoteDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$postsRemoteDataSourceHash();

  @$internal
  @override
  $FutureProviderElement<IPostsRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<IPostsRemoteDataSource> create(Ref ref) {
    return postsRemoteDataSource(ref);
  }
}

String _$postsRemoteDataSourceHash() =>
    r'532d201f3cecb4c62e48295f3a46506033977297';
