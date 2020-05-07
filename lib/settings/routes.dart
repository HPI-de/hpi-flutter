import 'package:flutter_deep_linking/flutter_deep_linking.dart';

import 'widgets/settings_page.dart';

final settingsRoutes = Route(
  matcher: Matcher.path('settings'),
  materialBuilder: (_, __) => SettingsPage(),
  routes: [
    Route(
      matcher: Matcher.path('privacyPolicy'),
      materialBuilder: (_, __) => PrivacyPolicyPage(),
    ),
  ],
);
