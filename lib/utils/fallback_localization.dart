import 'package:flutter/material.dart';

import '../../l10n/l10n.dart';

class FallbackLocalizationDelegate extends LocalizationsDelegate<MaterialLocalizations> {
  const FallbackLocalizationDelegate();
  @override
  bool isSupported(Locale locale) => L10n.all.contains(locale);

  @override
  Future<MaterialLocalizations> load(Locale locale) async =>
      const DefaultMaterialLocalizations();
  @override
  bool shouldReload(old) => true;
}
