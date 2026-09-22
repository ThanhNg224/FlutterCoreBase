// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The application's single source of truth for "is someone signed in?".
///
/// `null` data means signed out; `AsyncLoading` means the persisted session is
/// still being read, which the router shows as a splash rather than bouncing
/// the user to the login screen and back.

@ProviderFor(AuthController)
final authControllerProvider = AuthControllerProvider._();

/// The application's single source of truth for "is someone signed in?".
///
/// `null` data means signed out; `AsyncLoading` means the persisted session is
/// still being read, which the router shows as a splash rather than bouncing
/// the user to the login screen and back.
final class AuthControllerProvider extends $AsyncNotifierProvider<AuthController, AuthSession?> {
  /// The application's single source of truth for "is someone signed in?".
  ///
  /// `null` data means signed out; `AsyncLoading` means the persisted session is
  /// still being read, which the router shows as a splash rather than bouncing
  /// the user to the login screen and back.
  AuthControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authControllerHash();

  @$internal
  @override
  AuthController create() => AuthController();
}

String _$authControllerHash() => r'7924c7a7de20b5dfac67f6c9475e39a265e89f02';

/// The application's single source of truth for "is someone signed in?".
///
/// `null` data means signed out; `AsyncLoading` means the persisted session is
/// still being read, which the router shows as a splash rather than bouncing
/// the user to the login screen and back.

abstract class _$AuthController extends $AsyncNotifier<AuthSession?> {
  FutureOr<AuthSession?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<AuthSession?>, AuthSession?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AuthSession?>, AuthSession?>,
              AsyncValue<AuthSession?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
