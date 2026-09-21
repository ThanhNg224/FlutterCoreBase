import 'package:flutter/material.dart';
import 'package:flutter_core_base/core/extensions/context_extensions.dart';
import 'package:flutter_core_base/core/theme/app_spacing.dart';

/// Shown only while the persisted session is being read. Without it the router
/// would briefly decide "not signed in" and bounce a returning user through the
/// login screen on every cold start.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator.adaptive(),
            const SizedBox(height: AppSpacing.m),
            Text(
              context.l10n.restoringSessionMessage,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
