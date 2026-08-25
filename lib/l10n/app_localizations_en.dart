// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Flutter Core Base';

  @override
  String get settingsTooltip => 'Settings';

  @override
  String get catalogTitle => 'SDK Capability Catalog';

  @override
  String get catalogSubtitle => 'Explore integrated SDK features and capabilities in this demo host application.';

  @override
  String get developerSdkSettingsTitle => 'Developer & SDK Settings';

  @override
  String get sdkEnvironmentTitle => 'Environment Configuration';

  @override
  String get useDevServerLabel => 'Use Development Server';

  @override
  String get connectedDevEnvironment => 'Connected to Dev Environment';

  @override
  String get connectedProdEnvironment => 'Connected to Production Environment';

  @override
  String get activeBaseUrlLabel => 'Active Base URL:';

  @override
  String get mockSdkModeLabel => 'Mock SDK Mode';

  @override
  String get mockSdkModeDescription => 'Simulate native SDK responses without hardware dependencies';

  @override
  String get credentialsTitle => 'Credentials & Overrides';

  @override
  String get credentialsDescription =>
      'Overrides the built-in sandbox credentials for this device only. Leave untouched to keep the defaults.';

  @override
  String get appTokenLabel => 'App Token';

  @override
  String get clientKeyLabel => 'Client Key';

  @override
  String credentialsActiveHint(String value) {
    return 'Currently: $value';
  }

  @override
  String get resetCredentialsButton => 'Reset to defaults';

  @override
  String get credentialsResetMessage => 'Credential overrides cleared';

  @override
  String get saveCredentialsButton => 'Save credentials';

  @override
  String get credentialsSavedMessage => 'Credentials updated';

  @override
  String get appearanceThemeTitle => 'Appearance & Theme';

  @override
  String get themeModeLabel => 'Theme Mode';

  @override
  String get themeModeSystem => 'System';

  @override
  String get themeModeLight => 'Light';

  @override
  String get themeModeDark => 'Dark';

  @override
  String get languageTitle => 'Language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageVietnamese => 'Vietnamese';

  @override
  String get aboutTitle => 'About';

  @override
  String get sdkVersionLabel => 'Host App Version:';

  @override
  String get errorNetwork => 'Could not reach the server. Check your device\'s internet connection and try again.';

  @override
  String get errorServer => 'The server could not complete this request. Please try again in a moment.';

  @override
  String get errorUnauthorized =>
      'The server rejected these credentials. Check the app token and client key under Settings.';

  @override
  String get errorSdk => 'The native SDK could not finish the operation on this device.';

  @override
  String get errorStorage => 'Could not read the app\'s local settings.';

  @override
  String get errorUnexpected => 'Something went wrong. Please try again.';

  @override
  String get closeButton => 'Close';

  @override
  String get retryButton => 'Retry';

  @override
  String get cancelButton => 'Cancel';

  @override
  String get saveButton => 'Save';

  @override
  String get confirmButton => 'Confirm';

  @override
  String get somethingWentWrongMessage => 'Something went wrong';

  @override
  String pageNotFoundMessage(String uri) {
    return 'Page not found: $uri';
  }
}
