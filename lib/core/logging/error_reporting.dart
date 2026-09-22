import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_core_base/core/logging/app_logger.dart';
import 'package:flutter_core_base/core/logging/crash_reporter.dart';
import 'package:flutter_core_base/core/logging/redacted.dart';

const _log = AppLogger('ErrorReporting');

/// Single install point for the app's three global error boundaries:
/// `FlutterError.onError` (build/layout/paint errors raised by the
/// framework), `PlatformDispatcher.onError` (uncaught async errors) and
/// `ErrorWidget.builder` (what renders in place of a subtree that failed).
///
/// Call [install] once from `main()`, before `runApp`. A vendor SDK plugs in
/// without touching `main.dart` again: implement [CrashReporter] and pass it
/// as `reporter`.
///
/// [reporter] is always notified, even when `AppLogger`'s `LogPolicy` is
/// silencing the console — logging is silent-by-design in release, but a
/// crash must still be reported. Never gate the call to [CrashReporter] on
/// the logging policy.
///
/// Deliberately does not use `runZonedGuarded`: since Flutter 3.x,
/// `PlatformDispatcher.instance.onError` already receives every async error
/// that used to require a guarded zone, so layering one on top here would
/// only duplicate reporting and add complexity for no benefit.
abstract final class ErrorReporting {
  static CrashReporter _reporter = const NoopCrashReporter();
  static bool? _debugModeOverride;

  /// The reporter currently wired up, for diagnostics and tests.
  static CrashReporter get reporter => _reporter;

  /// Wires [handleFlutterError], [handlePlatformError] and, when supplied,
  /// [errorWidgetBuilder] into the global handlers. Call once from `main()`.
  static void install({CrashReporter? reporter, ErrorWidgetBuilder? errorWidgetBuilder}) {
    if (reporter != null) _reporter = reporter;
    FlutterError.onError = handleFlutterError;
    PlatformDispatcher.instance.onError = handlePlatformError;
    if (errorWidgetBuilder != null) ErrorWidget.builder = errorWidgetBuilder;
  }

  /// Handles a framework error caught during build/layout/paint.
  ///
  /// Logs it, then unconditionally forwards it to [reporter] as non-fatal:
  /// the app keeps running, since `ErrorWidget.builder` renders in place of
  /// the failed subtree.
  @visibleForTesting
  static void handleFlutterError(FlutterErrorDetails details) {
    _log.error(
      'uncaught flutter error',
      error: details.exception,
      stackTrace: details.stack,
      data: {'type': Redacted.type(details.exception)},
    );
    _reporter.recordError(details.exception, details.stack, fatal: false, context: details.library);
    // Keep the familiar red console dump while developing. A release build
    // has no console worth printing to, and AppLogger is already silent
    // there by policy.
    if (_isDebugMode) FlutterError.presentError(details);
  }

  /// Handles an uncaught async error from [PlatformDispatcher.onError].
  ///
  /// Logs it, then unconditionally forwards it to [reporter] as fatal —
  /// nothing downstream will run to recover from it.
  ///
  /// Returns whether the engine should consider the error handled: `false`
  /// in debug, so it still surfaces as a crash while developing; `true`
  /// otherwise, matching the previous behaviour in `main.dart`.
  @visibleForTesting
  static bool handlePlatformError(Object error, StackTrace stackTrace) {
    _log.error('uncaught async error', error: error, stackTrace: stackTrace, data: {'type': Redacted.type(error)});
    _reporter.recordError(error, stackTrace, fatal: true);
    return !_isDebugMode;
  }

  static bool get _isDebugMode => _debugModeOverride ?? kDebugMode;

  /// Pins the debug-mode seam for a test, independent of the real
  /// `kDebugMode` (which is always `true` under `flutter test`).
  @visibleForTesting
  static void setDebugModeForTest(bool? isDebugMode) => _debugModeOverride = isDebugMode;

  /// Sets [reporter] without touching the global `FlutterError.onError` /
  /// `PlatformDispatcher.onError` handlers, so a test can exercise
  /// [handleFlutterError] and [handlePlatformError] directly without
  /// mutating process-wide state that would leak into other tests.
  @visibleForTesting
  static void setReporterForTest(CrashReporter reporter) => _reporter = reporter;

  @visibleForTesting
  static void resetForTest() {
    _reporter = const NoopCrashReporter();
    _debugModeOverride = null;
  }
}
