import 'package:flutter_core_base/app/routing/auth_redirect.dart';
import 'package:flutter_core_base/core/routing/route_paths.dart';
import 'package:flutter_core_base/features/auth/domain/entities/auth_session.dart';
import 'package:flutter_core_base/features/auth/domain/entities/auth_user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

final _session = AuthSession(
  accessToken: 'access',
  refreshToken: 'refresh',
  expiresAt: DateTime(2100),
  user: const AuthUser(id: 'id', email: 'user@example.com', displayName: 'User'),
);

void main() {
  group('resolveAuthRedirect', () {
    test('loading + on splash stays put', () {
      final result = resolveAuthRedirect(
        session: const AsyncLoading<AuthSession?>(),
        location: RoutePaths.splash,
      );
      expect(result, isNull);
    });

    test('loading + elsewhere goes to splash', () {
      final result = resolveAuthRedirect(
        session: const AsyncLoading<AuthSession?>(),
        location: RoutePaths.catalog,
      );
      expect(result, RoutePaths.splash);
    });

    test('signed out + on login stays put', () {
      final result = resolveAuthRedirect(
        session: const AsyncData<AuthSession?>(null),
        location: RoutePaths.login,
      );
      expect(result, isNull);
    });

    test('signed out + at catalog goes to login', () {
      final result = resolveAuthRedirect(
        session: const AsyncData<AuthSession?>(null),
        location: RoutePaths.catalog,
      );
      expect(result, RoutePaths.login);
    });

    test('signed out + at settings goes to login', () {
      final result = resolveAuthRedirect(
        session: const AsyncData<AuthSession?>(null),
        location: RoutePaths.settings,
      );
      expect(result, RoutePaths.login);
    });

    test('signed in + on login goes to catalog', () {
      final result = resolveAuthRedirect(
        session: AsyncData<AuthSession?>(_session),
        location: RoutePaths.login,
      );
      expect(result, RoutePaths.catalog);
    });

    test('signed in + on splash goes to catalog', () {
      final result = resolveAuthRedirect(
        session: AsyncData<AuthSession?>(_session),
        location: RoutePaths.splash,
      );
      expect(result, RoutePaths.catalog);
    });

    test('signed in + at settings stays put', () {
      final result = resolveAuthRedirect(
        session: AsyncData<AuthSession?>(_session),
        location: RoutePaths.settings,
      );
      expect(result, isNull);
    });

    test('error is treated as signed out: goes to login', () {
      // session.value is null on AsyncError, same as the signed-out case, so
      // an auth failure bounces the user to the login screen rather than
      // stranding them or leaking a protected route.
      final result = resolveAuthRedirect(
        session: AsyncError<AuthSession?>(Exception('boom'), StackTrace.empty),
        location: RoutePaths.catalog,
      );
      expect(result, RoutePaths.login);
    });

    test('never redirects to the current location, for any session x route combination', () {
      final sessions = <AsyncValue<AuthSession?>>[
        const AsyncLoading<AuthSession?>(),
        const AsyncData<AuthSession?>(null),
        AsyncData<AuthSession?>(_session),
        AsyncError<AuthSession?>(Exception('boom'), StackTrace.empty),
      ];
      const locations = [
        RoutePaths.catalog,
        RoutePaths.posts,
        RoutePaths.postDetail,
        RoutePaths.settings,
        RoutePaths.splash,
        RoutePaths.login,
        RoutePaths.account,
      ];

      for (final session in sessions) {
        for (final location in locations) {
          final result = resolveAuthRedirect(session: session, location: location);
          expect(
            result,
            isNot(location),
            reason: 'session=$session location=$location redirected to itself: $result',
          );
        }
      }
    });
  });
}
