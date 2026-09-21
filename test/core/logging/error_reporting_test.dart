import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_core_base/core/logging/logging.dart';

import '../../support/recording_log_sink.dart';

final class _RecordedCrash {
  const _RecordedCrash(this.error, this.stackTrace, {required this.fatal, this.context});

  final Object error;
  final StackTrace? stackTrace;
  final bool fatal;
  final String? context;
}

final class _RecordingCrashReporter implements CrashReporter {
  final List<_RecordedCrash> crashes = [];

  @override
  void recordError(Object error, StackTrace? stackTrace, {required bool fatal, String? context}) {
    crashes.add(_RecordedCrash(error, stackTrace, fatal: fatal, context: context));
  }
}

void main() {
  late RecordingLogSink sink;
  late _RecordingCrashReporter crashReporter;

  setUp(() {
    sink = RecordingLogSink();
    crashReporter = _RecordingCrashReporter();
  });

  tearDown(() {
    AppLogger.restoreDefaults();
    ErrorReporting.resetForTest();
  });

  FlutterErrorDetails detailsFor(Object exception) =>
      FlutterErrorDetails(exception: exception, stack: StackTrace.current);

  group('ErrorReporting.handleFlutterError', () {
    test('sends the error to both the log sink and the reporter', () {
      AppLogger.installForTest(policy: const LogPolicy(isDebugBuild: true), sink: sink);
      ErrorReporting.setReporterForTest(crashReporter);

      final error = StateError('boom');
      ErrorReporting.handleFlutterError(detailsFor(error));

      expect(sink.records, hasLength(1));
      expect(sink.records.single.level, LogLevel.error);

      expect(crashReporter.crashes, hasLength(1));
      expect(crashReporter.crashes.single.error, same(error));
      expect(crashReporter.crashes.single.fatal, isFalse);
    });
  });

  group('ErrorReporting.handlePlatformError', () {
    test('reports the error as fatal', () {
      AppLogger.installForTest(policy: const LogPolicy(isDebugBuild: true), sink: sink);
      ErrorReporting.setReporterForTest(crashReporter);

      final error = StateError('async boom');
      ErrorReporting.handlePlatformError(error, StackTrace.current);

      expect(crashReporter.crashes, hasLength(1));
      expect(crashReporter.crashes.single.error, same(error));
      expect(crashReporter.crashes.single.fatal, isTrue);
    });

    test('returns true in a release-like build and false in a debug-like build via the test seam', () {
      AppLogger.installForTest(policy: const LogPolicy(isDebugBuild: true), sink: sink);
      ErrorReporting.setReporterForTest(crashReporter);

      ErrorReporting.setDebugModeForTest(true);
      expect(ErrorReporting.handlePlatformError(StateError('a'), StackTrace.current), isFalse);

      ErrorReporting.setDebugModeForTest(false);
      expect(ErrorReporting.handlePlatformError(StateError('b'), StackTrace.current), isTrue);
    });
  });

  group('the crash reporter always fires, even when logging is silenced', () {
    test('handleFlutterError still reaches the reporter under LogPolicy.release()', () {
      AppLogger.installForTest(policy: const LogPolicy.release(), sink: sink);
      ErrorReporting.setReporterForTest(crashReporter);
      ErrorReporting.setDebugModeForTest(false);

      ErrorReporting.handleFlutterError(detailsFor(StateError('silent build boom')));

      expect(sink.records, isEmpty, reason: 'LogPolicy.release() must silence the console');
      expect(crashReporter.crashes, hasLength(1), reason: 'crash reporting must not depend on the logging policy');
      expect(crashReporter.crashes.single.fatal, isFalse);
    });

    test('handlePlatformError still reaches the reporter under LogPolicy.release()', () {
      AppLogger.installForTest(policy: const LogPolicy.release(), sink: sink);
      ErrorReporting.setReporterForTest(crashReporter);
      ErrorReporting.setDebugModeForTest(false);

      ErrorReporting.handlePlatformError(StateError('silent async boom'), StackTrace.current);

      expect(sink.records, isEmpty, reason: 'LogPolicy.release() must silence the console');
      expect(crashReporter.crashes, hasLength(1), reason: 'crash reporting must not depend on the logging policy');
      expect(crashReporter.crashes.single.fatal, isTrue);
    });
  });

  group('default reporter', () {
    test('is a NoopCrashReporter and never throws', () {
      expect(ErrorReporting.reporter, isA<NoopCrashReporter>());

      expect(
        () => ErrorReporting.reporter.recordError(StateError('boom'), StackTrace.current, fatal: true),
        returnsNormally,
      );
    });
  });

  group('ErrorReporting.install', () {
    test('wires FlutterError.onError, PlatformDispatcher.onError and ErrorWidget.builder', () {
      final originalFlutterOnError = FlutterError.onError;
      final originalPlatformOnError = PlatformDispatcher.instance.onError;
      final originalErrorWidgetBuilder = ErrorWidget.builder;
      addTearDown(() {
        FlutterError.onError = originalFlutterOnError;
        PlatformDispatcher.instance.onError = originalPlatformOnError;
        ErrorWidget.builder = originalErrorWidgetBuilder;
      });

      AppLogger.installForTest(policy: const LogPolicy(isDebugBuild: true), sink: sink);
      Widget customBuilder(FlutterErrorDetails details) => const Placeholder();
      ErrorReporting.install(reporter: crashReporter, errorWidgetBuilder: customBuilder);

      expect(FlutterError.onError, ErrorReporting.handleFlutterError);
      expect(PlatformDispatcher.instance.onError, ErrorReporting.handlePlatformError);
      expect(ErrorWidget.builder, customBuilder);
    });
  });

  group('redaction', () {
    test('no log message embeds the raw exception toString()', () {
      AppLogger.installForTest(policy: const LogPolicy(isDebugBuild: true), sink: sink);
      ErrorReporting.setReporterForTest(crashReporter);

      final error = StateError('super secret failure detail');
      ErrorReporting.handleFlutterError(detailsFor(error));
      ErrorReporting.handlePlatformError(error, StackTrace.current);

      for (final record in sink.records) {
        expect(record.message, isNot(contains(error.toString())));
      }
    });
  });
}
