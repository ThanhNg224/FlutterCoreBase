import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_core_base/core/config/app_config.dart';

/// Resolves which backend environment this binary was *built* for.
///
/// Precedence is `--dart-define=APP_ENV` first, then the optional native build flavour
/// ([appFlavor]), then production.
///
/// Anything unrecognised resolves to [Environment.production]: a typo must
/// never silently point a release build at a development backend, and the
/// reverse (a dev build briefly hitting prod) is the louder, safer failure.
abstract final class AppEnvironment {
  static Environment? _testOverride;

  /// Raw `--dart-define=APP_ENV=...`; empty string when the define is absent.
  static const String dartDefine = String.fromEnvironment('APP_ENV');

  /// The environment baked into this binary.
  static Environment get build => _testOverride ?? resolve(dartDefine: dartDefine, flavor: appFlavor);

  @visibleForTesting
  static Environment resolve({required String dartDefine, required String? flavor}) {
    final token = (dartDefine.isNotEmpty ? dartDefine : flavor ?? '').trim().toLowerCase();
    return switch (token) {
      'dev' || 'development' => Environment.development,
      _ => Environment.production,
    };
  }

  /// Pins [build] for a test.
  @visibleForTesting
  static void setForTest(Environment? environment) => _testOverride = environment;

  @visibleForTesting
  static void resetForTest() => _testOverride = null;

  /// Refuses to let a release binary run against a non-production backend.
  @visibleForTesting
  static void verifyReleaseSafety({required bool isReleaseBuild, required Environment environment}) {
    if (!isReleaseBuild || environment == Environment.production) return;
    throw StateError(
      'Refusing to start: this is a release build resolved to $environment. '
      'Release builds must target production. Rebuild with '
      '`--dart-define=APP_ENV=prod` (or use `make build-apk-prod`).',
    );
  }

  /// Production call site for [verifyReleaseSafety]. Call once from `main()`.
  static void guardReleaseBuild() => verifyReleaseSafety(isReleaseBuild: kReleaseMode, environment: build);
}
