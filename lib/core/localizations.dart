import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kt_dart/kt.dart';
import 'package:sprintf/sprintf.dart';
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
    var lc = locale.languageCode ?? 'en';
    final strings = await rootBundle
        .loadString('assets/localizations/strings_$lc.yaml')
        .then((s) =>
            KtMap<String, String>.from(Map.from(loadYaml(s) as YamlMap)));

    // Load fallbacks
    KtMap<String, String> fallbacks;
    if (lc != 'en') {
      fallbacks = await rootBundle
          .loadString('assets/localizations/strings_en.yaml')
          .then((s) => KtMap.from(Map.from(loadYaml(s) as YamlMap)));
    }

    return HpiL11n._(locale, strings, fallbacks);
  }

  static HpiL11n of(BuildContext context) =>
      Localizations.of<HpiL11n>(context, HpiL11n);
  static String get(
    BuildContext context,
    String key, {
    String fallback,
    List<dynamic> args,
  }) =>
      Localizations.of<HpiL11n>(context, HpiL11n)(
        key,
        fallback: fallback,
        args: args,
      );
  static Text text(
    BuildContext context,
    String key, {
    String fallback,
    List<dynamic> args,
  }) =>
      Text(get(context, key, fallback: fallback, args: args));

  String call(String key, {String fallback, List<dynamic> args}) {
    assert(key != null);

    // Load
    var value = values[key];
    if (value == null) {
      print('String "$key" was not found in locale $locale');
    }

    // Try fallback
    if (value == null && fallback != null) {
      value = fallback;
    }

    // Try fallback resources
    if (value == null && fallbacks != null) {
      value = fallbacks[key];
    }

    // Still not found
    if (value == null) {
      final index = max(key.lastIndexOf('.'), key.lastIndexOf('/')) + 1;
      value = key.substring(max(index, 0));
    }

    // Apply formatting
    if (args != null) {
      value = sprintf(value, args);
    }

    return value;
  }
}

String enumToKey(Object enumValue) {
  assert(enumValue != null);

  final string = enumValue.toString();
  final key = string.substring(string.indexOf('.') + 1);
  return key[0].toLowerCase() + key.substring(1);
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
