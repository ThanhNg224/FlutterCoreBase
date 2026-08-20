// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'face_otp_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Auto-disposed controller managing Face OTP session and UI state

@ProviderFor(FaceOtpController)
final faceOtpControllerProvider = FaceOtpControllerProvider._();

/// Auto-disposed controller managing Face OTP session and UI state
final class FaceOtpControllerProvider
    extends $NotifierProvider<FaceOtpController, FaceOtpState> {
  /// Auto-disposed controller managing Face OTP session and UI state
  FaceOtpControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'faceOtpControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$faceOtpControllerHash();

  @$internal
  @override
  FaceOtpController create() => FaceOtpController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FaceOtpState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FaceOtpState>(value),
    );
  }
}

String _$faceOtpControllerHash() => r'36f08d3d58a9af2e7d20468ecd8b42b11c1f3ea5';

/// Auto-disposed controller managing Face OTP session and UI state

abstract class _$FaceOtpController extends $Notifier<FaceOtpState> {
  FaceOtpState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<FaceOtpState, FaceOtpState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<FaceOtpState, FaceOtpState>,
              FaceOtpState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
