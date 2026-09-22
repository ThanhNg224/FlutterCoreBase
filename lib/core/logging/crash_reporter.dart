/// Sink for errors that must survive the app session, independent of
/// [AppLogger]'s silent-in-release policy.
///
/// Wire a vendor SDK (Sentry, Crashlytics, ...) by implementing this and
/// passing it to `ErrorReporting.install(reporter: ...)` from `main()` — the
/// base ships with no such dependency.
abstract interface class CrashReporter {
  /// Records [error].
  ///
  /// [fatal] marks an error the app could not recover from (an uncaught
  /// async error that would otherwise crash the process); a caught, contained
  /// error — a widget build/layout/paint failure that `ErrorWidget.builder`
  /// absorbed — passes `fatal: false`. [context] is a short, non-sensitive
  /// breadcrumb (e.g. the framework library that raised it).
  void recordError(Object error, StackTrace? stackTrace, {required bool fatal, String? context});
}

/// Default [CrashReporter]. Does nothing, so the base ships without a vendor
/// dependency. A real project supplies its own implementation (Sentry,
/// Crashlytics, ...) via `ErrorReporting.install(reporter: ...)`.
final class NoopCrashReporter implements CrashReporter {
  const NoopCrashReporter();

  @override
  void recordError(Object error, StackTrace? stackTrace, {required bool fatal, String? context}) {}
}
