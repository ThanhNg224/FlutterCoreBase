/// Severity of a log record, ordered from most to least verbose.
///
/// Declaration order *is* the severity order — [isAtLeast] compares by index,
/// so inserting a new level in the middle is a deliberate, visible change.
enum LogLevel {
  /// High-frequency lifecycle churn (provider add/update/dispose). Off by
  /// default; enable it while chasing a specific rebuild.
  trace('T', '🔍'),

  /// The normal developer signal: HTTP calls, SDK steps, state transitions.
  debug('D', '🐛'),

  /// Milestones worth seeing without hunting: SDK initialised, config switched.
  info('I', 'ℹ️'),

  /// Recovered from, but someone should know: retry exhausted, permission denied.
  warn('W', '⚠️'),

  /// A failure that reached an error boundary.
  error('E', '❌');

  const LogLevel(this.label, this.glyph);

  /// Single-letter prefix used in the formatted line (`D/HTTP`).
  final String label;

  /// Scannable marker so a level stands out in a wall of logcat output.
  final String glyph;

  bool isAtLeast(LogLevel other) => index >= other.index;
}
