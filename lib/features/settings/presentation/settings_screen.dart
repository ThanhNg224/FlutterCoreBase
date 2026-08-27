import 'package:flutter/material.dart';
import 'package:flutter_core_base/core/config/app_config.dart';
import 'package:flutter_core_base/core/config/app_config_controller.dart';
import 'package:flutter_core_base/core/errors/failure_l10n.dart';
import 'package:flutter_core_base/core/localization/locale_provider.dart';
import 'package:flutter_core_base/core/theme/app_semantic_colors.dart';
import 'package:flutter_core_base/core/theme/app_spacing.dart';
import 'package:flutter_core_base/core/theme/theme_provider.dart';
import 'package:flutter_core_base/core/utils/redaction.dart';
import 'package:flutter_core_base/core/widgets/app_button.dart';
import 'package:flutter_core_base/core/widgets/app_card.dart';
import 'package:flutter_core_base/core/widgets/app_section_header.dart';
import 'package:flutter_core_base/core/widgets/app_snackbar.dart';
import 'package:flutter_core_base/core/widgets/app_text_field.dart';
import 'package:flutter_core_base/core/widgets/async_value_widget.dart';
import 'package:flutter_core_base/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n?.developerSdkSettingsTitle ?? 'Developer & SDK Settings')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppSpacing.maxContentWidth),
          child: ListView(
            padding: AppSpacing.pagePadding,
            children: [
              AppSectionHeader(title: l10n?.sdkEnvironmentTitle ?? 'Environment Configuration'),
              const _EnvironmentCard(),
              const SizedBox(height: AppSpacing.l),
              AppSectionHeader(
                title: l10n?.credentialsTitle ?? 'Credentials & Overrides',
                subtitle:
                    l10n?.credentialsDescription ?? 'Overrides the built-in sandbox credentials for this device only.',
              ),
              const _CredentialsCard(),
              const SizedBox(height: AppSpacing.l),
              AppSectionHeader(title: l10n?.appearanceThemeTitle ?? 'Appearance & Theme'),
              const _AppearanceCard(),
              const SizedBox(height: AppSpacing.l),
              AppSectionHeader(title: l10n?.aboutTitle ?? 'About'),
              const _AboutCard(),
            ],
          ),
        ),
      ),
    );
  }
}

class _EnvironmentCard extends ConsumerWidget {
  const _EnvironmentCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final controller = ref.read(appConfigControllerProvider.notifier);
    final configAsync = ref.watch(appConfigControllerProvider);

    return AsyncValueWidget<AppConfig>(
      value: configAsync,
      data: (config) {
        final isDev = config.environment == Environment.development;
        return AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n?.useDevServerLabel ?? 'Use Development Server'),
                subtitle: Text(
                  isDev
                      ? (l10n?.connectedDevEnvironment ?? 'Connected to Dev Environment')
                      : (l10n?.connectedProdEnvironment ?? 'Connected to Production Environment'),
                  style: textTheme.bodySmall,
                ),
                value: isDev,
                onChanged: controller.toggleEnvironment,
              ),
              const Divider(),
              Text(l10n?.activeBaseUrlLabel ?? 'Active Base URL:', style: textTheme.bodySmall),
              const SizedBox(height: 2),
              Text(
                config.baseUrl,
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.colors.brandAccent,
                ),
              ),
              const SizedBox(height: AppSpacing.m),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n?.mockSdkModeLabel ?? 'Mock SDK Mode'),
                subtitle: Text(
                  l10n?.mockSdkModeDescription ?? 'Simulate native SDK responses without hardware dependencies',
                  style: textTheme.bodySmall,
                ),
                value: config.mockSdkEnabled,
                onChanged: controller.toggleMockSdk,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CredentialsCard extends ConsumerStatefulWidget {
  const _CredentialsCard();

  @override
  ConsumerState<_CredentialsCard> createState() => _CredentialsCardState();
}

class _CredentialsCardState extends ConsumerState<_CredentialsCard> {
  final _appTokenController = TextEditingController();
  final _clientKeyController = TextEditingController();

  @override
  void dispose() {
    _appTokenController.dispose();
    _clientKeyController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final appToken = _appTokenController.text.trim();
    final clientKey = _clientKeyController.text.trim();
    if (appToken.isEmpty && clientKey.isEmpty) return;

    final result = await ref
        .read(appConfigControllerProvider.notifier)
        .updateCredentials(
          appToken: appToken.isEmpty ? null : appToken,
          clientKey: clientKey.isEmpty ? null : clientKey,
        );
    if (!mounted) return;
    final l10n = AppLocalizations.of(context);
    result.fold(
      (failure) => _confirm(
        l10n == null ? 'Unable to update credentials' : failure.localizedMessage(l10n),
        isError: true,
      ),
      (_) {
        _clearFields();
        _confirm(l10n?.credentialsSavedMessage ?? 'Credentials updated');
      },
    );
  }

  Future<void> _reset() async {
    final result = await ref.read(appConfigControllerProvider.notifier).clearCredentialOverrides();
    if (!mounted) return;
    final l10n = AppLocalizations.of(context);
    result.fold(
      (failure) => _confirm(
        l10n == null ? 'Unable to reset credentials' : failure.localizedMessage(l10n),
        isError: true,
      ),
      (_) {
        _clearFields();
        _confirm(l10n?.credentialsResetMessage ?? 'Credential overrides cleared');
      },
    );
  }

  void _clearFields() {
    _appTokenController.clear();
    _clientKeyController.clear();
    FocusScope.of(context).unfocus();
  }

  void _confirm(String message, {bool isError = false}) {
    if (isError) {
      AppSnackbar.showError(context, message);
      return;
    }
    AppSnackbar.showSuccess(context, message);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AsyncValueWidget<AppConfig>(
      value: ref.watch(appConfigControllerProvider),
      data: (config) => AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppTextField(
              label: l10n?.appTokenLabel ?? 'App Token',
              helperText:
                  l10n?.credentialsActiveHint(Redaction.secret(config.appToken)) ??
                  'Currently: ${Redaction.secret(config.appToken)}',
              controller: _appTokenController,
              prefixIcon: Icons.vpn_key_rounded,
            ),
            const SizedBox(height: AppSpacing.m),
            AppTextField(
              label: l10n?.clientKeyLabel ?? 'Client Key',
              helperText:
                  l10n?.credentialsActiveHint(Redaction.secret(config.clientKey)) ??
                  'Currently: ${Redaction.secret(config.clientKey)}',
              controller: _clientKeyController,
              prefixIcon: Icons.badge_rounded,
            ),
            const SizedBox(height: AppSpacing.m),
            AppButton(
              label: l10n?.saveCredentialsButton ?? 'Save credentials',
              variant: ButtonVariant.outline,
              icon: Icons.save_rounded,
              onPressed: _save,
            ),
            const SizedBox(height: AppSpacing.xs),
            TextButton(
              onPressed: _reset,
              child: Text(l10n?.resetCredentialsButton ?? 'Reset to defaults'),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppearanceCard extends ConsumerWidget {
  const _AppearanceCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;

    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);
    final currentLanguageCode = locale?.languageCode ?? Localizations.localeOf(context).languageCode;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n?.themeModeLabel ?? 'Theme Mode', style: textTheme.titleMedium),
          const SizedBox(height: AppSpacing.s),
          SizedBox(
            width: double.infinity,
            child: SegmentedButton<ThemeMode>(
              segments: [
                ButtonSegment(
                  value: ThemeMode.system,
                  label: Text(l10n?.themeModeSystem ?? 'System'),
                  icon: const Icon(Icons.brightness_auto),
                ),
                ButtonSegment(
                  value: ThemeMode.light,
                  label: Text(l10n?.themeModeLight ?? 'Light'),
                  icon: const Icon(Icons.light_mode),
                ),
                ButtonSegment(
                  value: ThemeMode.dark,
                  label: Text(l10n?.themeModeDark ?? 'Dark'),
                  icon: const Icon(Icons.dark_mode),
                ),
              ],
              selected: {themeMode},
              onSelectionChanged: (selection) => ref.read(themeModeProvider.notifier).setThemeMode(selection.first),
            ),
          ),
          const SizedBox(height: AppSpacing.m),
          Text(l10n?.languageTitle ?? 'Language', style: textTheme.titleMedium),
          const SizedBox(height: AppSpacing.s),
          SizedBox(
            width: double.infinity,
            child: SegmentedButton<String>(
              segments: [
                ButtonSegment(value: 'en', label: Text(l10n?.languageEnglish ?? 'English')),
                ButtonSegment(value: 'vi', label: Text(l10n?.languageVietnamese ?? 'Tiếng Việt')),
              ],
              selected: <String>{currentLanguageCode},
              onSelectionChanged: (selection) => ref.read(localeProvider.notifier).setLocale(Locale(selection.first)),
            ),
          ),
        ],
      ),
    );
  }
}

class _AboutCard extends ConsumerWidget {
  const _AboutCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return AsyncValueWidget<AppConfig>(
      value: ref.watch(appConfigControllerProvider),
      data: (config) => AppCard(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(l10n?.sdkVersionLabel ?? 'Host App Version:'),
            Text(
              'v${config.sdkVersion}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
