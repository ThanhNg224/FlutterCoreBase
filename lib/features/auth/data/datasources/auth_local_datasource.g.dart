// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_local_datasource.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(authLocalDataSource)
final authLocalDataSourceProvider = AuthLocalDataSourceProvider._();

final class AuthLocalDataSourceProvider
    extends $FunctionalProvider<IAuthLocalDataSource, IAuthLocalDataSource, IAuthLocalDataSource>
    with $Provider<IAuthLocalDataSource> {
  AuthLocalDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authLocalDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authLocalDataSourceHash();

  @$internal
  @override
  $ProviderElement<IAuthLocalDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  IAuthLocalDataSource create(Ref ref) {
    return authLocalDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IAuthLocalDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IAuthLocalDataSource>(value),
    );
  }
}

String _$authLocalDataSourceHash() => r'08cbd05282bae938078587d77056135e38c24775';
