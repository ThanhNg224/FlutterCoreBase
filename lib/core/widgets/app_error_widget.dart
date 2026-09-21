import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core_base/core/theme/app_colors.dart';
import 'package:flutter_core_base/core/theme/app_spacing.dart';

/// Replaces Flutter's default red/grey box when a subtree fails to build.
///
/// **Deliberately exempt from the design-system rules in `docs/STANDARD.md`.**
/// This is installed as [ErrorWidget.builder], so it renders *after* some
/// subtree has already failed — possibly above or outside [MaterialApp]. It
/// therefore cannot reach `context.colors` (a force-unwrapped theme extension
/// that would throw when absent) or `Theme.of(context).textTheme`, and it
/// supplies its own [Directionality] and [Material] for the same reason.
/// Raw [AppColors] tokens and literal [TextStyle]s here are the correct call:
/// an error fallback that can itself fail to render is worse than an
/// off-token one. It is also not localized, because `context.l10n` would
/// throw under exactly the same conditions.
///
/// In debug mode the exception details are shown; release builds show a
/// friendly panel.
class AppErrorWidget extends StatelessWidget {
  final FlutterErrorDetails details;

  const AppErrorWidget({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Material(
        color: AppColors.error.withValues(alpha: 0.04),
        child: Center(
          child: Padding(
            padding: AppSpacing.dialogPadding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline_rounded, size: 40, color: AppColors.error),
                const SizedBox(height: AppSpacing.m),
                const Text(
                  'Something went wrong',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                if (kDebugMode) ...[
                  const SizedBox(height: AppSpacing.s),
                  Text(
                    '${details.exception}',
                    textAlign: TextAlign.center,
                    maxLines: 6,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12, color: AppColors.errorOnLight),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
