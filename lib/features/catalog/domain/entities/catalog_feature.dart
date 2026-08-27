import 'package:freezed_annotation/freezed_annotation.dart';

part 'catalog_feature.freezed.dart';

enum FeatureCategory { data, ui, config, security }

abstract class CatalogIconKeys {
  static const String feed = 'feed';
  static const String settings = 'settings';
  static const String architecture = 'architecture';
}

/// Pure-Dart entity describing a core showcase capability.
@freezed
abstract class CatalogFeature with _$CatalogFeature {
  const factory CatalogFeature({
    required String id,
    required String title,
    required String description,
    required String routePath,
    required FeatureCategory category,
    required String iconKey,
    @Default(true) bool isEnabled,
    @Default(<String>[]) List<String> tags,
  }) = _CatalogFeature;
}
