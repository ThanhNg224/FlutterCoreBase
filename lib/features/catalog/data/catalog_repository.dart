import 'package:flutter/material.dart';
import 'package:flutter_core_base/core/routing/route_paths.dart';
import 'package:flutter_core_base/features/catalog/domain/sdk_feature.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'catalog_repository.g.dart';

abstract interface class ICatalogRepository {
  Future<List<SdkFeature>> getFeatures();
}

class CatalogRepository implements ICatalogRepository {
  @override
  Future<List<SdkFeature>> getFeatures() async {
    // Simulated fetch (can be extended to remote config or SDK plugin reflection)
    await Future.delayed(const Duration(milliseconds: 100));
    return const [
      SdkFeature(
        id: 'face_otp',
        title: 'Face OTP Verification',
        description: 'Biometric face matching with passive 3D liveness detection.',
        routePath: RoutePaths.faceOtp,
        category: SdkCategory.biometric,
        icon: Icons.face_retouching_natural_rounded,
        tags: ['Biometric', 'Liveness', 'FaceID'],
      ),
      SdkFeature(
        id: 'id_ocr',
        title: 'ID Card OCR',
        description: 'Front & back national ID scanning and text extraction.',
        routePath: '/id-ocr',
        category: SdkCategory.identity,
        icon: Icons.badge_outlined,
        isEnabled: false,
        tags: ['Identity', 'OCR', 'Coming Soon'],
      ),
      SdkFeature(
        id: 'nfc_reader',
        title: 'Chip ID NFC Reader',
        description: 'Read and verify cryptographic chip data from passport / ID.',
        routePath: '/nfc-reader',
        category: SdkCategory.security,
        icon: Icons.nfc_rounded,
        isEnabled: false,
        tags: ['NFC', 'Chip', 'Coming Soon'],
      ),
    ];
  }
}

@Riverpod(keepAlive: true)
ICatalogRepository catalogRepository(Ref ref) {
  return CatalogRepository();
}
