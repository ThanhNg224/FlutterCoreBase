// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_dio_client.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// A Dio deliberately built **without** `AuthInterceptor`.
///
/// Two callers need it: the auth data source (a refresh request must not be
/// retried by the very interceptor that triggered it — that is an infinite
/// loop), and `AuthInterceptor` itself when replaying a request after a
/// successful refresh.

@ProviderFor(authDio)
final authDioProvider = AuthDioProvider._();

/// A Dio deliberately built **without** `AuthInterceptor`.
///
/// Two callers need it: the auth data source (a refresh request must not be
/// retried by the very interceptor that triggered it — that is an infinite
/// loop), and `AuthInterceptor` itself when replaying a request after a
/// successful refresh.

final class AuthDioProvider extends $FunctionalProvider<AsyncValue<Dio>, Dio, FutureOr<Dio>>
    with $FutureModifier<Dio>, $FutureProvider<Dio> {
  /// A Dio deliberately built **without** `AuthInterceptor`.
  ///
  /// Two callers need it: the auth data source (a refresh request must not be
  /// retried by the very interceptor that triggered it — that is an infinite
  /// loop), and `AuthInterceptor` itself when replaying a request after a
  /// successful refresh.
  AuthDioProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authDioProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authDioHash();

  @$internal
  @override
  $FutureProviderElement<Dio> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<Dio> create(Ref ref) {
    return authDio(ref);
  }
}

String _$authDioHash() => r'b1e356996869cbb69eef0033681b5068ce3df75d';
