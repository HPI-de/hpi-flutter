import 'package:black_hole_flutter/black_hole_flutter.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hpi_flutter/core/core.dart';
import 'package:hpi_flutter/generated/l10n.dart';
import 'package:hpi_flutter/main.dart';
import 'package:hpi_flutter/onboarding/onboarding.dart';
import 'package:navigation_patterns/navigation_patterns.dart';
import 'package:outline_material_icons/outline_material_icons.dart';

import '../routing.dart';
import '../services/navigation.dart';
import 'hpi_theme.dart';
import 'theme.dart';

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
            ? appSchemeUrl('main')
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

class MainPage extends StatelessWidget {
  const MainPage();

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final theme = context.theme;
    final barColor = theme.bottomAppBarColor;

    return BottomNavigationPattern(
      tabCount: _BottomTab.values.length,
      navigatorBuilder: (_, tabIndex, navigatorKey) {
        return Navigator(
          key: navigatorKey,
          initialRoute: _BottomTab.values[tabIndex].initialRoute,
          onGenerateRoute: router.onGenerateRoute,
        );
      },
      scaffoldBuilder: (_, body, selectedTabIndex, onTabSelected) {
        return Scaffold(
          body: body,
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: theme.accentColor,
            unselectedItemColor: theme.mediumEmphasisOnBackground,
            currentIndex: selectedTabIndex,
            onTap: onTabSelected,
            items: [
              for (final tab in _BottomTab.values)
                BottomNavigationBarItem(
                  icon: Icon(tab.icon, key: tab.key),
                  title: Text(tab.title(s)),
                  backgroundColor: barColor,
                ),
            ],
          ),
        );
      },
    );
  }
}

typedef L10nStringGetter = String Function(S);

@immutable
class _BottomTab {
  const _BottomTab({
    this.key,
    @required this.icon,
    @required this.title,
    @required this.initialRoute,
  })  : assert(icon != null),
        assert(title != null),
        assert(initialRoute != null);

  final ValueKey key;
  final IconData icon;
  final L10nStringGetter title;
  final String initialRoute;

  static final values = [dashboard, courses, food, myhpi, tools];

  // We don't use relative URLs as they would start with a '/' and hence the
  // navigator automatically populates our initial back stack with '/'.
  static final dashboard = _BottomTab(
    icon: OMIcons.home,
    title: (s) => s.dashboard,
    initialRoute: mdWebUrl('dashboard'),
  );
  static final courses = _BottomTab(
    icon: OMIcons.school,
    title: (s) => s.course,
    initialRoute: mdWebUrl('courses'),
  );
  static final food = _BottomTab(
    icon: OMIcons.restaurantMenu,
    title: (s) => s.food,
    initialRoute: mdWebUrl('food'),
  );
  static final myhpi = _BottomTab(
    icon: HpiIcons.myhpi,
    title: (s) => s.myhpi,
    initialRoute: mdWebUrl('myhpi'),
  );
  static final news = _BottomTab(
    icon: HpiIcons.newspaper,
    title: (s) => s.news,
    initialRoute: mdWebUrl('news'),
  );
  static final tools = _BottomTab(
    icon: HpiIcons.tools,
    title: (s) => s.tools,
    initialRoute: mdWebUrl('tools/timer'),
  );
}
