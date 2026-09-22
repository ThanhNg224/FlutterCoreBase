import 'package:flutter/material.dart';
import 'package:flutter_core_base/app/app.dart';
import 'package:flutter_core_base/app/observers/app_provider_observer.dart';
import 'package:flutter_core_base/core/config/app_environment.dart';
import 'package:flutter_core_base/core/logging/logging.dart';
import 'package:flutter_core_base/core/storage/storage_providers.dart';
import 'package:flutter_core_base/core/widgets/app_error_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  // Fails fast if a release binary resolved to a non-production backend.
  // Release builds must target production via `--dart-define=APP_ENV=prod`.
  // Crashing here is loud and catchable, whereas quietly calling the dev API
  // from a shipped app is not.
  AppEnvironment.guardReleaseBuild();

  WidgetsFlutterBinding.ensureInitialized();

  // Wires FlutterError.onError, PlatformDispatcher.onError and
  // ErrorWidget.builder to AppLogger and (once configured) a CrashReporter.
  ErrorReporting.install(errorWidgetBuilder: (details) => AppErrorWidget(details: details));

  // Initialize async core infrastructure before runApp
  final sharedPrefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      observers: [
        AppProviderObserver(),
      ],
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPrefs),
      ],
      child: const FlutterCoreBaseApp(),
    ),
  );
}
