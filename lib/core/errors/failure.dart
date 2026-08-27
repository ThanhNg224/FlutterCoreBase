import 'package:freezed_annotation/freezed_annotation.dart';

part 'failure.freezed.dart';

/// Represents domain-level failure objects for functional error handling
@freezed
sealed class Failure with _$Failure {
  const factory Failure.server({
    required String message,
    int? statusCode,
  }) = ServerFailure;

  const factory Failure.network({
    @Default('Network connection failed. Please check your internet.') String message,
  }) = NetworkFailure;

  const factory Failure.platform({
    required String message,
    String? errorCode,
  }) = PlatformFailure;

  const factory Failure.storage({
    required String message,
  }) = StorageFailure;

  const factory Failure.unauthorized({
    @Default('Session expired or unauthorized. Please re-authenticate.') String message,
  }) = UnauthorizedFailure;

  const factory Failure.unexpected({
    required String message,
  }) = UnexpectedFailure;
}
