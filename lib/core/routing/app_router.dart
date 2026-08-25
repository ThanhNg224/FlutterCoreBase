import 'package:flutter/material.dart';
import 'package:flutter_core_base/core/routing/route_paths.dart';
import 'package:flutter_core_base/features/catalog/presentation/catalog_screen.dart';
import 'package:flutter_core_base/features/face_otp/presentation/views/face_otp_screen.dart';
import 'package:flutter_core_base/features/settings/presentation/settings_screen.dart';
import 'package:flutter_core_base/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'rootNav');

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RoutePaths.catalog,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: RoutePaths.catalog,
        builder: (context, state) => const CatalogScreen(),
      ),
      GoRoute(
        path: RoutePaths.faceOtp,
        builder: (context, state) => const FaceOtpScreen(),
      ),
      GoRoute(
        path: RoutePaths.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text(
          AppLocalizations.of(context)?.pageNotFoundMessage(state.uri.toString()) ??
              'Page not found: ${state.uri}',
        ),
      ),
    ),
  );
}
