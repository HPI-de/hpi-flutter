import 'package:flutter/material.dart' hide Route;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hpi_flutter/app/app.dart';
import 'package:hpi_flutter/generated/l10n.dart';
import 'package:hpi_flutter/onboarding/onboarding.dart';

import '../../route.dart';
import '../services/navigation.dart';
import 'hpi_theme.dart';

class HpiApp extends StatelessWidget {
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
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
      ),
    );
  }
}
