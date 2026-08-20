import 'package:flutter/material.dart';
import 'package:flutter_core_base/core/theme/app_colors.dart';
import 'package:flutter_core_base/core/theme/app_spacing.dart';
import 'package:flutter_core_base/core/theme/app_typography.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      error: error ??
          (err, st) => Center(
                child: Padding(
                  padding: AppSpacing.pagePadding,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline_rounded, color: AppColors.error, size: 48),
                      const SizedBox(height: AppSpacing.m),
                      Text(
                        'Something went wrong',
                        style: AppTypography.titleMedium.copyWith(color: AppColors.error),
                      ),
                      const SizedBox(height: AppSpacing.s),
                      Text(
                        err.toString(),
                        style: AppTypography.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
      loading: loading ??
          () => const Center(
                child: CircularProgressIndicator(),
              ),
    );
  }
}
