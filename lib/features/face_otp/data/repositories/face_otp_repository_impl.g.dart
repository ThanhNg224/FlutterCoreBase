// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'face_otp_repository_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(faceOtpRepository)
final faceOtpRepositoryProvider = FaceOtpRepositoryProvider._();

final class FaceOtpRepositoryProvider
    extends
        $FunctionalProvider<
          IFaceOtpRepository,
          IFaceOtpRepository,
          IFaceOtpRepository
        >
    with $Provider<IFaceOtpRepository> {
  FaceOtpRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'faceOtpRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$faceOtpRepositoryHash();

  @$internal
  @override
  $ProviderElement<IFaceOtpRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  IFaceOtpRepository create(Ref ref) {
    return faceOtpRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IFaceOtpRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IFaceOtpRepository>(value),
    );
  }
}

String _$faceOtpRepositoryHash() => r'd3e373bc6bdfe3e73472e1f1d76769250f25acfc';
