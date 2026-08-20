import 'package:flutter/material.dart';
import 'package:flutter_core_base/core/theme/app_spacing.dart';
import 'package:flutter_core_base/core/theme/app_typography.dart';
import 'package:flutter_core_base/core/theme/theme_provider.dart';
import 'package:flutter_core_base/core/widgets/app_card.dart';
import 'package:flutter_core_base/features/settings/domain/app_settings.dart';
import 'package:flutter_core_base/features/settings/presentation/settings_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final themeController = ref.read(themeModeProvider.notifier);

    final settings = ref.watch(settingsControllerProvider);
    final settingsController = ref.read(settingsControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Host App Settings'),
      ),
      body: ListView(
        padding: AppSpacing.pagePadding,
        children: [
          // Appearance
          Text('Appearance & Theme', style: AppTypography.titleLarge),
          const SizedBox(height: AppSpacing.s),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Select Theme Mode', style: AppTypography.titleMedium),
                const SizedBox(height: AppSpacing.s),
                SizedBox(
                  width: double.infinity,
                  child: SegmentedButton<ThemeMode>(
                    segments: const [
                      ButtonSegment(value: ThemeMode.system, label: Text('System'), icon: Icon(Icons.brightness_auto)),
                      ButtonSegment(value: ThemeMode.light, label: Text('Light'), icon: Icon(Icons.light_mode)),
                      ButtonSegment(value: ThemeMode.dark, label: Text('Dark'), icon: Icon(Icons.dark_mode)),
                    ],
                    selected: {themeMode},
                    onSelectionChanged: (newSet) {
                      themeController.setThemeMode(newSet.first);
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.l),

          // Environment
          Text('Backend & SDK Environment', style: AppTypography.titleLarge),
          const SizedBox(height: AppSpacing.s),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<Environment>(
                  decoration: const InputDecoration(
                    labelText: 'Target Environment',
                    border: OutlineInputBorder(),
                  ),
                  initialValue: settings.environment,
                  items: Environment.values.map((env) {
                    return DropdownMenuItem(
                      value: env,
                      child: Text(env.name.toUpperCase()),
                    );
                  }).toList(),
                  onChanged: (newEnv) {
                    if (newEnv != null) {
                      settingsController.updateEnvironment(newEnv);
                    }
                  },
                ),
                const SizedBox(height: AppSpacing.m),
                Text('Base URL:', style: AppTypography.caption),
                Text(settings.baseUrl, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                const Divider(height: AppSpacing.l),
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Mock SDK Mode'),
                  subtitle: const Text('Simulate native SDK responses without hardware dependencies'),
                  value: settings.mockSdkEnabled,
                  onChanged: settingsController.toggleMockSdk,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
