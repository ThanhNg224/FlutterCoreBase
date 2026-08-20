import 'package:flutter_core_base/core/errors/failure.dart';
import 'package:flutter_core_base/features/face_otp/domain/entities/face_otp_config.dart';
import 'package:flutter_core_base/features/face_otp/domain/entities/face_otp_result.dart';
import 'package:fpdart/fpdart.dart';

/// Contract for Face OTP SDK interactions
abstract interface class IFaceOtpRepository {
  Future<Either<Failure, FaceOtpResult>> startVerification({
    required FaceOtpConfig config,
  });

  Future<Either<Failure, bool>> cancelVerification();
}
