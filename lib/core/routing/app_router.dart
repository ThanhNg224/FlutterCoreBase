import 'package:flutter/material.dart';
import 'package:flutter_core_base/core/extensions/context_extensions.dart';
import 'package:flutter_core_base/core/routing/route_paths.dart';
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
