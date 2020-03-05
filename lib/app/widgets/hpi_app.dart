import 'package:flutter/material.dart' hide Route;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hpi_flutter/app/app.dart';
import 'package:hpi_flutter/core/core.dart';
import 'package:hpi_flutter/onboarding/onboarding.dart';

import '../../route.dart';
import '../services/navigation.dart';
import 'hpi_theme.dart';

class HpiApp extends StatelessWidget {
  final localizationsDelegate = HpiLocalizationsDelegate();

  @override
  Widget build(BuildContext context) {
    return HpiTheme(
      tertiary: Color(0xFFF6A804),
      child: MaterialApp(
        title: 'HPI',
        theme: buildTheme(Brightness.light),
        darkTheme: buildTheme(Brightness.dark),
        initialRoute: OnboardingPage.isOnboardingCompleted
            ? Route.dashboard.name
            : Route.onboarding.name,
        onGenerateRoute: Route.generateRoute,
        navigatorObservers: [
          NavigationObserver(),
        ],
        localizationsDelegates: [
          localizationsDelegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: localizationsDelegate.supportedLanguages
            .map((l) => Locale(l))
            .asList(),
      ),
    );
  }
}
