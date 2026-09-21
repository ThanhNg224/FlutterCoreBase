import 'package:dio/dio.dart';
import 'package:flutter_core_base/core/config/app_config_controller.dart';
import 'package:flutter_core_base/core/constants/api_endpoints.dart';
import 'package:flutter_core_base/core/constants/app_constants.dart';
import 'package:flutter_core_base/core/errors/app_exception.dart';
import 'package:flutter_core_base/core/network/auth_dio_client.dart';
import 'package:flutter_core_base/features/auth/data/models/auth_session_dto.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_remote_datasource.g.dart';

abstract interface class IAuthRemoteDataSource {
  Future<AuthSessionDto> login({required String email, required String password});
  Future<AuthSessionDto> refresh(String refreshToken);
  Future<void> logout(String refreshToken);
}

class AuthRemoteDataSource implements IAuthRemoteDataSource {
  final Dio dio;
  final bool isMock;

  const AuthRemoteDataSource({required this.dio, this.isMock = false});

  /// The credential the mock branch rejects, so the failure path is reachable
  /// in the demo without a backend.
  static const String mockRejectedEmail = 'locked@example.com';

  @override
  Future<AuthSessionDto> login({required String email, required String password}) async {
    if (isMock) {
      await Future<void>.delayed(AppConstants.mockSdkDelay);
      if (email.trim().toLowerCase() == mockRejectedEmail) {
        throw const UnauthorizedException(message: 'mock: credentials rejected');
      }
      return _mockSession(email: email);
    }

    final response = await dio.post<Map<String, dynamic>>(
      ApiEndpoints.login,
      data: {'email': email, 'password': password},
    );
    return AuthSessionDto.fromJson(response.data!);
  }

  @override
  Future<AuthSessionDto> refresh(String refreshToken) async {
    if (isMock) {
      await Future<void>.delayed(AppConstants.mockSdkDelay);
      if (refreshToken.isEmpty) {
        throw const UnauthorizedException(message: 'mock: refresh token rejected');
      }
      return _mockSession(email: 'demo@example.com');
    }

    final response = await dio.post<Map<String, dynamic>>(
      ApiEndpoints.refresh,
      data: {'refreshToken': refreshToken},
    );
    return AuthSessionDto.fromJson(response.data!);
  }

  @override
  Future<void> logout(String refreshToken) async {
    if (isMock) {
      await Future<void>.delayed(AppConstants.mockSdkDelay);
      return;
    }
    await dio.post<void>(ApiEndpoints.logout, data: {'refreshToken': refreshToken});
  }

  AuthSessionDto _mockSession({required String email}) {
    final issuedAt = DateTime.now();
    final stamp = issuedAt.millisecondsSinceEpoch;
    return AuthSessionDto(
      accessToken: 'mock-access-$stamp',
      refreshToken: 'mock-refresh-$stamp',
      expiresAt: issuedAt.add(const Duration(minutes: 15)),
      userId: 'mock-user',
      email: email.trim(),
      displayName: email.split('@').first,
    );
  }
}

@Riverpod(keepAlive: true)
Future<IAuthRemoteDataSource> authRemoteDataSource(Ref ref) async {
  final dio = await ref.watch(authDioProvider.future);
  final config = await ref.watch(appConfigControllerProvider.future);
  return AuthRemoteDataSource(dio: dio, isMock: config.mockSdkEnabled);
}
