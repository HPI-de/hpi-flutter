import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:yaml/yaml.dart';
import 'package:flutter/services.dart';

class HpiL11n {
  HpiL11n(this.locale) {
    var lc = locale.languageCode;
    rootBundle
        .loadString(
            'assets/localizations/strings_${lc != null ? lc : "en"}.yaml')
        .then((strings) => _localizedValues = Map.from(loadYaml(strings)));
  }

  Future<void> _loadStrings() async {
    var lc = locale.languageCode;
    var strings = await rootBundle.loadString(
        'assets/localizations/strings_${lc != null ? lc : "en"}.yaml');
    _localizedValues = _localizedValues = Map.from(loadYaml(strings));
  }

  final Locale locale;
  Map<String, String> _localizedValues;

  String loadFallbacks(String key) {
    print('String "$key" was not found in locale ${locale.languageCode}');
    rootBundle
        .loadString('assets/localizations/strings_en.yaml')
        .then((strings) {
      YamlMap fallbackStrings = loadYaml(strings);
      fallbackStrings.forEach((k, v) =>
          !_localizedValues.keys.contains(k) ? _localizedValues[k] = v : null);
    });
    return _localizedValues[key] ?? key;
  }

  static HpiL11n of(BuildContext context) =>
      Localizations.of<HpiL11n>(context, HpiL11n);

  String operator [](String key) {
    // This is only a temporary solution to stop errors from appearing.
    if (_localizedValues == null) return key;
    return _localizedValues[key] ?? loadFallbacks(key);
  }
}

class HpiLocalizationsDelegate extends LocalizationsDelegate<HpiL11n> {
  @override
  bool isSupported(Locale locale) => ['en', 'de'].contains(locale.languageCode);

  @override
  Future<HpiL11n> load(Locale locale) =>
      SynchronousFuture<HpiL11n>(HpiL11n(locale));

  @override
  bool shouldReload(LocalizationsDelegate<HpiL11n> old) => false;
}
