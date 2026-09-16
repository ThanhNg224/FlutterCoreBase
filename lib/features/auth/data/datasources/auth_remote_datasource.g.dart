// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_remote_datasource.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(authRemoteDataSource)
final authRemoteDataSourceProvider = AuthRemoteDataSourceProvider._();

final class AuthRemoteDataSourceProvider
    extends
        $FunctionalProvider<AsyncValue<IAuthRemoteDataSource>, IAuthRemoteDataSource, FutureOr<IAuthRemoteDataSource>>
    with $FutureModifier<IAuthRemoteDataSource>, $FutureProvider<IAuthRemoteDataSource> {
  AuthRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authRemoteDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authRemoteDataSourceHash();

  @$internal
  @override
  $FutureProviderElement<IAuthRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<IAuthRemoteDataSource> create(Ref ref) {
    return authRemoteDataSource(ref);
  }
}

String _$authRemoteDataSourceHash() => r'8c3a806601a064a70f21f2cabce698f650101a98';
