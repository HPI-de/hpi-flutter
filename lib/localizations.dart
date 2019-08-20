import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HpiLocalizations {
  HpiLocalizations(this.locale);

  final Locale locale;

  static HpiLocalizations of(BuildContext context) =>
      Localizations.of<HpiLocalizations>(context, HpiLocalizations);

  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'dashboard': 'Dashboard',
      'courses': 'Courses',
      'food': 'Food',
      'myhpi': 'MyHPI',
      'news': 'News',
    },
    'de': {
      'dashboard': 'Übersicht',
      'courses': 'Kurse',
      'food': 'Speisepläne',
      'myhpi': 'MyHPI',
      'news': 'Neuigkeiten',
    }
  };

  String get dashboard => _localizedValues[locale.languageCode]['dashboard'];
  String get courses => _localizedValues[locale.languageCode]['courses'];
  String get food => _localizedValues[locale.languageCode]['food'];
  String get myhpi => _localizedValues[locale.languageCode]['myhpi'];
  String get news => _localizedValues[locale.languageCode]['news'];
}

class HpiLocalizationsDelegate extends LocalizationsDelegate<HpiLocalizations> {
  @override
  bool isSupported(Locale locale) => ['en', 'de'].contains(locale.languageCode);

  @override
  Future<HpiLocalizations> load(Locale locale) =>
      SynchronousFuture<HpiLocalizations>(HpiLocalizations(locale));

  @override
  bool shouldReload(LocalizationsDelegate<HpiLocalizations> old) => false;
}
