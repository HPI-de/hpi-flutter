import 'package:black_hole_flutter/black_hole_flutter.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hpi_flutter/app/app.dart';
import 'package:hpi_flutter/generated/l10n.dart';
import 'package:hpi_flutter/main.dart';
import 'package:hpi_flutter/onboarding/onboarding.dart';

import '../routing.dart';
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
            ? mdWebUrl('dashboard')
            : mdWebUrl('onboarding'),
        builder: (context, child) {
          onLocaleChanged(context.locale);
          return child;
        },
        onGenerateRoute: router.onGenerateRoute,
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
