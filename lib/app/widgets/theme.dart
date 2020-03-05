import 'package:flutter/material.dart';

const _brandColorRed = 0xFFB1063A;
const _brandColorRedSwatch = MaterialColor(
  _brandColorRed,
  <int, Color>{
    50: Color(0xFFFBE2E6),
    100: Color(0xFFF6B6C1),
    200: Color(0xFFEE8799),
    300: Color(0xFFE55872),
    400: Color(0xFFDD3656),
    500: Color(0xFFD4143D),
    600: Color(0xFFC50E3C),
    700: Color(_brandColorRed),
    800: Color(0xFF9E0037),
    900: Color(0xFF7C0033),
  },
);
const _brandColorOrange = 0xFFDD6108;
// ignore: unused_element
const _brandColorOrangeSwatch = MaterialColor(
  _brandColorOrange,
  <int, Color>{
    50: Color(0xFFFDF4E2),
    100: Color(0xFFFBE3B6),
    200: Color(0xFFF9D186),
    300: Color(0xFFF8BE56),
    400: Color(0xFFF7B033),
    500: Color(0xFFF6A21B),
    600: Color(0xFFF29716),
    700: Color(0xFFED8711),
    800: Color(0xFFE6780D),
    900: Color(_brandColorOrange),
  },
);
// ignore: unused_element
const _brandColorYellow = 0xFFF6A804;

ThemeData buildTheme(Brightness brightness) {
  final isDark = brightness == Brightness.dark;

  ThemeData theme = ThemeData(
    brightness: brightness,
    primarySwatch: _brandColorRedSwatch,
    // By default, the [primaryColor] is set to a dark grey in dark mode
    primaryColor: _brandColorRedSwatch,
    primaryColorLight:
        isDark ? _brandColorRedSwatch[500] : _brandColorRedSwatch[300],
    primaryColorDark:
        isDark ? _brandColorRedSwatch[800] : _brandColorRedSwatch[700],
    accentColor: Color(_brandColorOrange),
    fontFamily: 'Neo Sans',
  );
  theme = theme.copyWith(
    textTheme: theme.textTheme.copyWith(
        overline: theme.textTheme.overline.copyWith(
          color: isDark ? Colors.white60 : Colors.black.withOpacity(0.6),
          fontWeight: FontWeight.w500,
          fontSize: 10,
          letterSpacing: 1.5,
          height: 1.6,
        ),
        headline: theme.textTheme.headline.copyWith(
          fontFamily: 'Neo Sans',
        )),
  );
  var localizedTheme = ThemeData.localize(
    theme,
    theme.typography.geometryThemeFor(ScriptCategory.englishLike),
  );
  theme = theme.copyWith(
    cardTheme: theme.cardTheme.copyWith(
      shape: BeveledRectangleBorder(),
    ),
    chipTheme: theme.chipTheme.copyWith(
      backgroundColor: Colors.transparent,
      shape: StadiumBorder(side: BorderSide(color: Colors.black12)),
    ),
    appBarTheme: theme.appBarTheme.copyWith(
      actionsIconTheme: theme.iconTheme,
      brightness: brightness,
      color: isDark ? Colors.grey.shade900 : Colors.grey.shade50,
      iconTheme: theme.iconTheme,
      textTheme: localizedTheme.textTheme,
    ),
    floatingActionButtonTheme: theme.floatingActionButtonTheme.copyWith(
      backgroundColor: theme.primaryColor,
      shape: BeveledRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
    ),
  );
  theme = theme.copyWith(
    bottomAppBarTheme: theme.bottomAppBarTheme.copyWith(
      shape: AutomaticNotchedShape(
        BeveledRectangleBorder(),
        theme.floatingActionButtonTheme.shape,
      ),
    ),
  );

  return theme;
}
