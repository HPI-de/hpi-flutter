import 'package:flutter_deep_linking/flutter_deep_linking.dart';

import 'widgets/onboarding_page.dart';

final onboardingRoutes = Route(
  matcher: Matcher.path('onboarding'),
  materialBuilder: (_, __) => OnboardingPage(),
);
