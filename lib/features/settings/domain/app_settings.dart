import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_settings.freezed.dart';

enum Environment { development, staging, production }

@freezed
abstract class AppSettings with _$AppSettings {
  const factory AppSettings({
    @Default(Environment.development) Environment environment,
    @Default(true) bool mockSdkEnabled,
    @Default('https://api-dev.kalapa.vn') String baseUrl,
  }) = _AppSettings;
}
