import 'package:flutter_deep_linking/flutter_deep_linking.dart';

import 'widgets/timer_page.dart';

final toolsRoutes = Route(
  matcher: Matcher.path('tools'),
  routes: [
    Route(
      matcher: Matcher.path('timer'),
      materialBuilder: (_, result) => TimerPage(),
    ),
  ],
);
