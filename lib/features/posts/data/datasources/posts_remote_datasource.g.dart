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
          IPostsRemoteDataSource,
          IPostsRemoteDataSource,
          IPostsRemoteDataSource
        >
    with $Provider<IPostsRemoteDataSource> {
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
  $ProviderElement<IPostsRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  IPostsRemoteDataSource create(Ref ref) {
    return postsRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IPostsRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IPostsRemoteDataSource>(value),
    );
  }
}

String _$postsRemoteDataSourceHash() =>
    r'de45394e690f02369ece58bd1ddb8cbab354b682';
