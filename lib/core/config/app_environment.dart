import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_core_base/core/config/app_config.dart';

/// Resolves which backend environment this binary was *built* for.
///
/// Precedence is `--dart-define=APP_ENV` first, then the native build flavour
/// ([appFlavor], from `--flavor dev|prod`), then production.
///
/// `--dart-define` comes first because [appFlavor] cannot be trusted as an
/// intentional signal here: `pubspec.yaml` declares `default-flavor: dev`, and
/// Flutter injects `cliFlavor ?? defaultFlavor` into *every* command — so
/// [appFlavor] reads `'dev'` even under a bare `flutter test`, and never null.
/// An explicit define is the only way to say "production" and be believed.
///
/// Anything unrecognised resolves to [Environment.production]: a typo must
/// never silently point a release build at a development backend, and the
/// reverse (a dev build briefly hitting prod) is the louder, safer failure.
/// That rule cannot save a release build from `default-flavor: dev`, though,
/// because `dev` is a valid token — [guardReleaseBuild] covers that case.
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
  ///
  /// This seam exists because `pubspec.yaml` declares `default-flavor: dev`,
  /// which Flutter injects into every command including `flutter test` — so
  /// the ambient [build] under test is `development`, not a neutral default.
  /// Tests that care about a specific environment must say so.
  @visibleForTesting
  static void setForTest(Environment? environment) => _testOverride = environment;

  @visibleForTesting
  static void resetForTest() => _testOverride = null;

  /// Refuses to let a release binary run against a non-production backend.
  ///
  /// `default-flavor: dev` means a hand-typed `flutter build --release` with no
  /// `--flavor` compiles as dev. Crashing at launch is loud, catchable in QA,
  /// and strictly better than a shipped app quietly talking to the dev API.
  @visibleForTesting
  static void verifyReleaseSafety({required bool isReleaseBuild, required Environment environment}) {
    if (!isReleaseBuild || environment == Environment.production) return;
    throw StateError(
      'Refusing to start: this is a release build resolved to $environment. '
      'pubspec.yaml sets `default-flavor: dev`, so a release build without an '
      'explicit flavor compiles as dev. Rebuild with '
      '`--flavor prod --dart-define=APP_ENV=prod` (or use `make build-apk-prod`).',
    );
  }

  /// Production call site for [verifyReleaseSafety]. Call once from `main()`.
  static void guardReleaseBuild() => verifyReleaseSafety(isReleaseBuild: kReleaseMode, environment: build);
}
