import 'package:flutter_core_base/core/errors/failure.dart';
import 'package:flutter_core_base/features/face_otp/data/repositories/face_otp_repository_impl.dart';
import 'package:flutter_core_base/features/face_otp/domain/entities/face_otp_config.dart';
import 'package:flutter_core_base/features/face_otp/domain/entities/face_otp_result.dart';
import 'package:flutter_core_base/features/face_otp/domain/repositories/face_otp_repository.dart';
import 'package:flutter_core_base/features/face_otp/presentation/controllers/face_otp_controller.dart';
import 'package:flutter_core_base/features/face_otp/presentation/state/face_otp_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockFaceOtpRepository extends Mock implements IFaceOtpRepository {}

void main() {
  setUpAll(() {
    registerFallbackValue(const FaceOtpConfig());
  });

  group('FaceOtpController', () {
    late MockFaceOtpRepository mockRepository;
    late ProviderContainer container;

    setUp(() {
      mockRepository = MockFaceOtpRepository();
      container = ProviderContainer(
        overrides: [
          faceOtpRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('initial state should be FaceOtpInitialState with default config', () {
      final state = container.read(faceOtpControllerProvider);
      expect(state, isA<FaceOtpInitialState>());
      expect(state.config.livenessThreshold, 0.85);
    });

    test('updateLivenessThreshold should update threshold value in state', () {
      final controller = container.read(faceOtpControllerProvider.notifier);
      controller.updateLivenessThreshold(0.95);

      final state = container.read(faceOtpControllerProvider);
      expect(state.config.livenessThreshold, 0.95);
    });

    test('startVerification should transition to success when repository succeeds', () async {
      final mockResult = FaceOtpResult(
        sessionId: 'sess_123',
        status: VerificationStatus.success,
        similarityScore: 0.98,
        livenessScore: 0.95,
        token: 'test_token',
        verifiedAt: DateTime.now(),
      );

      when(() => mockRepository.startVerification(config: any(named: 'config')))
          .thenAnswer((_) async => Right(mockResult));

      final controller = container.read(faceOtpControllerProvider.notifier);
      await controller.startVerification();

      final state = container.read(faceOtpControllerProvider);
      expect(state, isA<FaceOtpSuccessState>());
      expect((state as FaceOtpSuccessState).result.token, 'test_token');
    });

    test('startVerification should transition to failure when repository fails', () async {
      const mockFailure = Failure.sdk(message: 'Liveness check failed', errorCode: 'ERR_101');

      when(() => mockRepository.startVerification(config: any(named: 'config')))
          .thenAnswer((_) async => const Left(mockFailure));

      final controller = container.read(faceOtpControllerProvider.notifier);
      await controller.startVerification();

      final state = container.read(faceOtpControllerProvider);
      expect(state, isA<FaceOtpFailureState>());
      expect((state as FaceOtpFailureState).failure.message, 'Liveness check failed');
    });
  });
}
