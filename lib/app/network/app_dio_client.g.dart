// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_dio_client.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The application's HTTP client.
///
/// Lives in `lib/app/` rather than `core/` because wiring `AuthInterceptor`
/// means reaching into the auth feature, and `core` is not allowed to know
/// features exist. Composition is the composition root's job.

@ProviderFor(dioClient)
final dioClientProvider = DioClientProvider._();

/// The application's HTTP client.
///
/// Lives in `lib/app/` rather than `core/` because wiring `AuthInterceptor`
/// means reaching into the auth feature, and `core` is not allowed to know
/// features exist. Composition is the composition root's job.

final class DioClientProvider extends $FunctionalProvider<AsyncValue<Dio>, Dio, FutureOr<Dio>>
    with $FutureModifier<Dio>, $FutureProvider<Dio> {
  /// The application's HTTP client.
  ///
  /// Lives in `lib/app/` rather than `core/` because wiring `AuthInterceptor`
  /// means reaching into the auth feature, and `core` is not allowed to know
  /// features exist. Composition is the composition root's job.
  DioClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dioClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dioClientHash();

  @$internal
  @override
  $FutureProviderElement<Dio> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<Dio> create(Ref ref) {
    return dioClient(ref);
  }
}

String _$dioClientHash() => r'42f7fd139497b9217737b5c7b1ff8c853a21ed86';
