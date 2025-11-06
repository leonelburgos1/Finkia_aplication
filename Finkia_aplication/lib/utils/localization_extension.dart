import 'package:flutter/widgets.dart';
import 'package:agrou_aplication/l10n/app_localizations.dart';

extension LocalizedContext on BuildContext {
  AppLocalizations get local => AppLocalizations.of(this)!;
}
