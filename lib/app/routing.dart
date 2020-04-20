import 'package:flutter_deep_linking/flutter_deep_linking.dart';
import 'package:hpi_flutter/course/course.dart';
import 'package:hpi_flutter/food/food.dart';
import 'package:hpi_flutter/myhpi/myhpi.dart';
import 'package:hpi_flutter/news/news.dart';
import 'package:hpi_flutter/onboarding/onboarding.dart';
import 'package:hpi_flutter/settings/settings.dart';
import 'package:hpi_flutter/tools/tools.dart';

import 'widgets/dashboard_page.dart';

const mdHost = 'mobiledev.hpi.de';
String mdWebUrl(String path) => 'https://$mdHost/$path';

final router = Router(
  routes: [
    Route(
      matcher: Matcher.webHost(mdHost, isOptional: true),
      routes: [
        courseRoutes,
        Route(
          matcher: Matcher.path('dashboard'),
          materialBuilder: (_, __) => DashboardPage(),
        ),
        foodRoutes,
        myhpiRoutes,
        newsRoutes,
        onboardingRoutes,
        toolsRoutes,
        settingsRoutes,
      ],
    ),
    // Route(materialBuilder: (_, result) => NotFoundScreen(result.uri)),
  ],
);
