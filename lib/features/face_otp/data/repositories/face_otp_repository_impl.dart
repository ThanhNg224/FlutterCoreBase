import 'package:flutter_core_base/core/errors/error_handler.dart';
import 'package:flutter_core_base/core/errors/failure.dart';
import 'package:flutter_core_base/features/face_otp/data/datasources/face_otp_sdk_datasource.dart';
import 'package:flutter_core_base/features/face_otp/domain/entities/face_otp_config.dart';
import 'package:flutter_core_base/features/face_otp/domain/entities/face_otp_result.dart';
import 'package:flutter_core_base/features/face_otp/domain/repositories/face_otp_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'face_otp_repository_impl.g.dart';

class FaceOtpRepositoryImpl implements IFaceOtpRepository {
  final IFaceOtpSdkDataSource _dataSource;

  FaceOtpRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, FaceOtpResult>> startVerification({
    required FaceOtpConfig config,
  }) async {
    return ErrorHandler.guard(() async {
      final dto = await _dataSource.launchVerification(config);
      return dto.toDomain();
    });
  }

  @override
  Future<Either<Failure, bool>> cancelVerification() async {
    return ErrorHandler.guard(() async {
      return _dataSource.cancelVerification();
    });
  }
}

@Riverpod(keepAlive: true)
IFaceOtpRepository faceOtpRepository(Ref ref) {
  final dataSource = ref.watch(faceOtpSdkDataSourceProvider);
  return FaceOtpRepositoryImpl(dataSource);
}
