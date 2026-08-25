import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_core_base/core/constants/app_constants.dart';
import 'package:flutter_core_base/core/localization/locale_provider.dart';
import 'package:flutter_core_base/core/routing/app_router.dart';
import 'package:flutter_core_base/core/theme/app_theme.dart';
import 'package:flutter_core_base/core/theme/theme_provider.dart';
import 'package:flutter_core_base/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Root application widget configuring Theme, Localization, and GoRouter.
class FlutterCoreBaseApp extends ConsumerWidget {
  const FlutterCoreBaseApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
    );
  }
}
