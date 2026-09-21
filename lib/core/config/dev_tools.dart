import 'package:flutter/foundation.dart';
import 'package:flutter_core_base/core/config/app_config.dart';
import 'package:flutter_core_base/core/config/app_environment.dart';

/// Answers a single question: may this build mutate its own runtime
/// configuration (backend environment, credentials, mock mode)?
///
/// These switches are debugging affordances. In a shipped production build
/// they are an attack surface — anyone could repoint the app at a development
/// backend or paste in an arbitrary token — so they are compiled off rather
/// than merely hidden.
abstract final class DevTools {
  static bool? _testOverride;

  /// True for any non-release build, and for release builds of a non-production
  /// environment (so QA can still drive a release-mode dev build).
  static bool get isEnabled =>
      _testOverride ?? computeEnabled(isReleaseBuild: kReleaseMode, environment: AppEnvironment.build);

  /// The rule itself, separated from the ambient build so it can be tested as a
  /// truth table rather than only in whatever mode the suite happens to run in.
  @visibleForTesting
  static bool computeEnabled({required bool isReleaseBuild, required Environment environment}) =>
      !isReleaseBuild || environment != Environment.production;

  @visibleForTesting
  static void setEnabledForTest(bool? value) => _testOverride = value;

  @visibleForTesting
  static void resetForTest() => _testOverride = null;
}
