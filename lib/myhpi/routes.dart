import 'package:flutter_deep_linking/flutter_deep_linking.dart';

import 'widgets/infobit_page.dart';
import 'widgets/myhpi_page.dart';

final myhpiRoutes = Route(
  matcher: Matcher.path('myhpi'),
  materialBuilder: (_, __) => MyHpiPage(),
  routes: [
    Route(
      matcher: Matcher.path('{infoBitId}'),
      materialBuilder: (_, result) => InfoBitPage(result['infoBitId']),
    ),
  ],
);
