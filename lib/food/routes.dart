import 'package:flutter_deep_linking/flutter_deep_linking.dart';

import 'widgets/food_page.dart';

final foodRoutes = Route(
  matcher: Matcher.path('food'),
  materialBuilder: (_, __) => FoodPage(),
);
