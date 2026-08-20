import 'package:flutter/material.dart';
import 'package:flutter_core_base/core/constants/app_constants.dart';
import 'package:flutter_core_base/core/routing/app_router.dart';
import 'package:flutter_core_base/core/theme/app_theme.dart';
import 'package:flutter_core_base/core/theme/theme_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Root application widget configuring Theme and GoRouter
class FlutterCoreBaseApp extends ConsumerWidget {
  const FlutterCoreBaseApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
