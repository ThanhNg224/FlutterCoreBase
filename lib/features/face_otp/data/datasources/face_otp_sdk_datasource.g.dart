// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'face_otp_sdk_datasource.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(faceOtpSdkDataSource)
final faceOtpSdkDataSourceProvider = FaceOtpSdkDataSourceProvider._();

final class FaceOtpSdkDataSourceProvider
    extends
        $FunctionalProvider<
          IFaceOtpSdkDataSource,
          IFaceOtpSdkDataSource,
          IFaceOtpSdkDataSource
        >
    with $Provider<IFaceOtpSdkDataSource> {
  FaceOtpSdkDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'faceOtpSdkDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$faceOtpSdkDataSourceHash();

  @$internal
  @override
  $ProviderElement<IFaceOtpSdkDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  IFaceOtpSdkDataSource create(Ref ref) {
    return faceOtpSdkDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IFaceOtpSdkDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IFaceOtpSdkDataSource>(value),
    );
  }
}

String _$faceOtpSdkDataSourceHash() =>
    r'f0c47920c6dc1d505828d21ffac2078adcee7208';
