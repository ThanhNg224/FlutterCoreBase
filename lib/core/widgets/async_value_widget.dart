import 'package:flutter/material.dart';
import 'package:flutter_core_base/core/errors/failure.dart';
import 'package:flutter_core_base/core/errors/failure_l10n.dart';
import 'package:flutter_core_base/core/extensions/context_extensions.dart';
import 'package:flutter_core_base/core/logging/logging.dart';
import 'package:flutter_core_base/core/theme/app_semantic_colors.dart';
import 'package:flutter_core_base/core/theme/app_spacing.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const _log = AppLogger('AsyncValueWidget');

/// Reusable helper to render [AsyncValue] cleanly with loading, error, and data states
class AsyncValueWidget<T> extends StatelessWidget {
  final AsyncValue<T> value;
  final Widget Function(T data) data;
  final Widget Function(Object error, StackTrace stackTrace)? error;
  final Widget Function()? loading;

  const AsyncValueWidget({
    super.key,
    required this.value,
    required this.data,
    this.error,
    this.loading,
  });

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: data,
      error:
          error ??
          (err, st) {
            final message = switch (err) {
              Failure() => err.localizedMessage(context.l10n),
              _ => context.l10n.somethingWentWrongMessage,
            };
            if (err is! Failure) {
              _log.error('unexpected AsyncValue error', data: {'errorType': Redacted.type(err)});
            }

            final colors = context.colors;
            final textTheme = Theme.of(context).textTheme;

            return Center(
              child: Padding(
                padding: AppSpacing.pagePadding,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.error_outline_rounded, color: colors.statusError, size: 48),
                    const SizedBox(height: AppSpacing.m),
                    Text(
                      context.l10n.somethingWentWrongMessage,
                      style: textTheme.titleMedium?.copyWith(color: colors.statusError),
                    ),
                    const SizedBox(height: AppSpacing.s),
                    Text(
                      message,
                      style: textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
      loading: loading ?? () => const Center(child: CircularProgressIndicator.adaptive()),
    );
  }
}
