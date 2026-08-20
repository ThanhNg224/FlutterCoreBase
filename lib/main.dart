import 'package:flutter/material.dart';
import 'package:flutter_core_base/app/app.dart';
import 'package:flutter_core_base/app/observers/app_provider_observer.dart';
import 'package:flutter_core_base/core/storage/storage_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
