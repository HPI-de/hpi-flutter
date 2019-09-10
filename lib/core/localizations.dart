import 'package:flutter/material.dart';
import 'package:kt_dart/kt.dart';
import 'package:yaml/yaml.dart';
import 'package:flutter/services.dart';

class HpiL11n {
  HpiL11n._(this.locale, this.values, this.fallbacks)
      : assert(locale != null),
        assert(values != null);

  final Locale locale;
  KtMap<String, String> values;
  KtMap<String, String> fallbacks;

  static Future<HpiL11n> load(Locale locale) async {
    // Load translations
    var lc = locale.languageCode ?? "en";
    var strings = await rootBundle
        .loadString(
            'assets/localizations/strings_${lc != null ? lc : "en"}.yaml')
        .then((s) => KtMap.from(loadYaml(s)));

    // Load fallbacks
    KtMap<String, String> fallbacks;
    if (lc != "en")
      fallbacks = await rootBundle
          .loadString('assets/localizations/strings_en.yaml')
          .then((s) => KtMap.from(loadYaml(s)));

    return HpiL11n._(locale, strings, fallbacks);
  }

  static HpiL11n of(BuildContext context) =>
      Localizations.of<HpiL11n>(context, HpiL11n);

  String operator [](String key) {
    var value = values[key];
    if (value != null) return value;
    print('String "$key" was not found in locale $locale');

    if (fallbacks != null) return fallbacks[key];
    return null;
  }
}

class HpiLocalizationsDelegate extends LocalizationsDelegate<HpiL11n> {
  final supportedLanguages = KtList.of('en', 'de');

  @override
  bool isSupported(Locale locale) =>
      supportedLanguages.contains(locale.languageCode);

  @override
  Future<HpiL11n> load(Locale locale) => HpiL11n.load(locale);

  @override
  bool shouldReload(LocalizationsDelegate<HpiL11n> old) => false;
}
