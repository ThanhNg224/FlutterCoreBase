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

  @override
  Future<AuthSession?> build() async {
    final repository = await ref.watch(authRepositoryProvider.future);
    final result = await repository.restoreSession();
    return result.getOrElse((_) => null);
  }

  String? get currentAccessToken => state.value?.accessToken;

  Future<Either<Failure, void>> login({required String email, required String password}) async {
    final repository = await ref.read(authRepositoryProvider.future);
    final result = await repository.login(email: email, password: password);

    return result.fold(
      (failure) {
        _log.warn('login rejected', data: {'failure': Redacted.type(failure)});
        return Left(failure);
      },
      (session) {
        state = AsyncData(session);
        return const Right(null);
      },
    );
  }

  Future<void> logout() async {
    final repository = await ref.read(authRepositoryProvider.future);
    await repository.logout();
    state = const AsyncData(null);
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
    _refreshInFlight = completer;

    unawaited(
      _performRefresh(current.refreshToken).then(
        (token) {
          _refreshInFlight = null;
          completer.complete(token);
        },
        onError: (Object error, StackTrace stackTrace) {
          _refreshInFlight = null;
          completer.complete(null);
          _log.error('refresh crashed', error: error, stackTrace: stackTrace);
        },
      ),
    );

    return completer.future;
  }

  Future<String?> _performRefresh(String refreshToken) async {
    final repository = await ref.read(authRepositoryProvider.future);
    final result = await repository.refresh(refreshToken);

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
}
