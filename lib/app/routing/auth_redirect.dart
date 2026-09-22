import 'package:flutter_core_base/core/routing/route_paths.dart';
import 'package:flutter_core_base/features/auth/domain/entities/auth_session.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

/// Decides where an incoming navigation should land, given the session.
///
/// Pure on purpose: the redirect is the subtlest part of the auth flow — a
/// wrong arm here is an infinite navigation loop — and as a free function it
/// is testable without building a router or booting a device.
///
/// Returns `null` to mean "stay where you are".
String? resolveAuthRedirect({
  required AsyncValue<AuthSession?> session,
  required String location,
}) {
  if (session.isLoading) {
    return location == RoutePaths.splash ? null : RoutePaths.splash;
  }

  final isSignedIn = session.value != null;
  final isOnAuthRoute = location == RoutePaths.login || location == RoutePaths.splash;

  // Returning the current location would make GoRouter loop, so each arm
  // returns null once the user is already where they belong.
  if (!isSignedIn) return location == RoutePaths.login ? null : RoutePaths.login;
  if (isOnAuthRoute) return RoutePaths.catalog;
  return null;
}
