import 'package:flutter/material.dart';
import 'package:flutter_core_base/app/routing/auth_redirect.dart';
import 'package:flutter_core_base/core/extensions/context_extensions.dart';
import 'package:flutter_core_base/core/routing/route_paths.dart';
import 'package:flutter_core_base/features/auth/domain/entities/auth_session.dart';
import 'package:flutter_core_base/features/auth/presentation/controllers/auth_controller.dart';
import 'package:flutter_core_base/features/auth/presentation/views/account_screen.dart';
import 'package:flutter_core_base/features/auth/presentation/views/login_screen.dart';
import 'package:flutter_core_base/features/auth/presentation/views/splash_screen.dart';
import 'package:flutter_core_base/features/catalog/presentation/catalog_screen.dart';
import 'package:flutter_core_base/features/posts/presentation/views/post_detail_screen.dart';
import 'package:flutter_core_base/features/posts/presentation/views/posts_screen.dart';
import 'package:flutter_core_base/features/settings/presentation/settings_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'rootNav');

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  // GoRouter needs a Listenable to know when to re-run `redirect`. Bridge the
  // provider into one rather than rebuilding the router on every auth change,
  // which would drop the navigation stack.
  final authState = ValueNotifier<AsyncValue<AuthSession?>>(const AsyncLoading());
  ref.listen(authControllerProvider, (_, next) => authState.value = next, fireImmediately: true);
  ref.onDispose(authState.dispose);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RoutePaths.catalog,
    debugLogDiagnostics: true,
    refreshListenable: authState,
    redirect: (context, state) => resolveAuthRedirect(
      session: authState.value,
      location: state.matchedLocation,
    ),
    routes: [
      GoRoute(
        path: RoutePaths.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RoutePaths.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RoutePaths.catalog,
        builder: (context, state) => const CatalogScreen(),
      ),
      GoRoute(
        path: RoutePaths.posts,
        builder: (context, state) => const PostsScreen(),
        routes: [
          GoRoute(
            path: ':id',
            builder: (context, state) {
              final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 1;
              return PostDetailScreen(postId: id);
            },
          ),
        ],
      ),
      GoRoute(
        path: RoutePaths.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: RoutePaths.account,
        builder: (context, state) => const AccountScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text(
          context.l10n.pageNotFoundMessage(state.uri.toString()),
        ),
      ),
    ),
  );
}
