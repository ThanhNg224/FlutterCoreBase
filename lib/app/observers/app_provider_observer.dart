import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Centralized state observer for logging and telemetry in Riverpod
base class AppProviderObserver extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderObserverContext context,
    Object? previousValue,
    Object? newValue,
  ) {
    if (kDebugMode) {
      debugPrint('⚡ [RIVERPOD UPDATE] ${context.provider.name ?? context.provider.runtimeType}');
      debugPrint('   Old: $previousValue');
      debugPrint('   New: $newValue');
    }
  }

  @override
  void didAddProvider(
    ProviderObserverContext context,
    Object? value,
  ) {
    if (kDebugMode) {
      debugPrint('➕ [RIVERPOD ADD] ${context.provider.name ?? context.provider.runtimeType}');
    }
  }

  @override
  void didDisposeProvider(
    ProviderObserverContext context,
  ) {
    if (kDebugMode) {
      debugPrint('🗑️ [RIVERPOD DISPOSE] ${context.provider.name ?? context.provider.runtimeType}');
    }
  }
}
