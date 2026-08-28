import 'package:flutter/widgets.dart';
import 'package:flutter_core_base/l10n/app_localizations.dart';

extension ContextExtensions on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
