import 'package:flutter/material.dart';
import 'package:flutter_core_base/core/extensions/context_extensions.dart';
import 'package:flutter_core_base/core/theme/app_spacing.dart';
import 'package:flutter_core_base/core/widgets/app_button.dart';
import 'package:flutter_core_base/core/widgets/app_card.dart';
import 'package:flutter_core_base/features/auth/presentation/controllers/auth_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Shows who is signed in and offers sign-out.
///
/// Lives in `features/auth` rather than as a card inside Settings so that the
/// settings feature never imports the auth feature. Settings reaches it by
/// route path only.
class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final session = ref.watch(authControllerProvider).value;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.sessionSectionTitle)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppSpacing.maxContentWidth),
          child: ListView(
            padding: AppSpacing.pagePadding,
            children: [
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(l10n.signedInAsLabel, style: textTheme.bodySmall),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      session?.user.email ?? '—',
                      style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: AppSpacing.m),
                    AppButton(
                      label: l10n.logoutButton,
                      variant: ButtonVariant.outline,
                      icon: Icons.logout_rounded,
                      // On success the router's redirect sends the user to login.
                      onPressed: () => ref.read(authControllerProvider.notifier).logout(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
