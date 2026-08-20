import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sdk_feature.freezed.dart';

enum SdkCategory { biometric, identity, security, utility }

/// Entity describing an SDK showcase capability
@freezed
abstract class SdkFeature with _$SdkFeature {
  const factory SdkFeature({
    required String id,
    required String title,
    required String description,
    required String routePath,
    required SdkCategory category,
    required IconData icon,
    @Default(true) bool isEnabled,
    @Default([]) List<String> tags,
  }) = _SdkFeature;
}
