import 'dart:async';

import 'package:flutter_core_base/core/errors/failure.dart';
import 'package:flutter_core_base/core/logging/logging.dart';
import 'package:flutter_core_base/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_core_base/features/auth/domain/entities/auth_session.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_controller.g.dart';

const _log = AppLogger('Auth.Controller');

/// The application's single source of truth for "is someone signed in?".
///
/// `null` data means signed out; `AsyncLoading` means the persisted session is
/// still being read, which the router shows as a splash rather than bouncing
/// the user to the login screen and back.
@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {
  Completer<String?>? _refreshInFlight;
  int _sessionGeneration = 0;

  @override
  Future<AuthSession?> build() async {
    final repository = await ref.watch(authRepositoryProvider.future);
    final result = await repository.restoreSession();
    return result.getOrElse((_) => null);
  }

  String? get currentAccessToken => state.value?.accessToken;

  Future<Either<Failure, void>> login({required String email, required String password}) async {
    final generation = _beginNewSessionGeneration();
    final repository = await ref.read(authRepositoryProvider.future);
    final result = await repository.login(
      email: email,
      password: password,
      isSessionCurrent: () => generation == _sessionGeneration,
    );

    return result.fold(
      (failure) {
        _log.warn('login rejected', data: {'failure': Redacted.type(failure)});
        return Left(failure);
      },
      (session) {
        if (generation == _sessionGeneration) state = AsyncData(session);
        return const Right(null);
      },
    );
  }

  Future<void> logout() async {
    final generation = _beginNewSessionGeneration();
    state = const AsyncData(null);
    final repository = await ref.read(authRepositoryProvider.future);
    await repository.logout(isSessionCurrent: () => generation == _sessionGeneration);
  }

  /// Exchanges the stored refresh token for a new access token.
  ///
  /// Single-flight: a burst of 401s must produce one refresh, not one per
  /// request. Returns the new access token, or `null` when there is nothing to
  /// refresh or the refresh was rejected — in which case the session is gone
  /// and the router will redirect to login.
  Future<String?> refreshSession() {
    final inFlight = _refreshInFlight;
    if (inFlight != null) return inFlight.future;

    final current = state.value;
    if (current == null) return Future.value();

    final completer = Completer<String?>();
    final generation = _sessionGeneration;
    _refreshInFlight = completer;

    unawaited(
      _performRefresh(current.refreshToken, generation).then(
        (token) {
          if (identical(_refreshInFlight, completer)) {
            _refreshInFlight = null;
            if (!completer.isCompleted) completer.complete(token);
          }
        },
        onError: (Object error, StackTrace stackTrace) {
          if (identical(_refreshInFlight, completer)) {
            _refreshInFlight = null;
            if (!completer.isCompleted) completer.complete(null);
          }
          _log.error('refresh crashed', error: error, stackTrace: stackTrace);
        },
      ),
    );

    return completer.future;
  }

  Future<String?> _performRefresh(String refreshToken, int generation) async {
    final repository = await ref.read(authRepositoryProvider.future);
    final result = await repository.refresh(
      refreshToken,
      isSessionCurrent: () => generation == _sessionGeneration,
    );

    if (generation != _sessionGeneration) return null;

    return result.fold(
      (failure) {
        state = const AsyncData(null);
        return null;
      },
      (session) {
        state = AsyncData(session);
        return session.accessToken;
      },
    );
  }

  int _beginNewSessionGeneration() {
    _sessionGeneration++;
    final inFlight = _refreshInFlight;
    _refreshInFlight = null;
    if (inFlight != null && !inFlight.isCompleted) inFlight.complete(null);
    return _sessionGeneration;
  }
}
