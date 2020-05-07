import 'package:flutter_deep_linking/flutter_deep_linking.dart';

import 'widgets/article_page.dart';
import 'widgets/news_page.dart';

final newsRoutes = Route(
  matcher: Matcher.path('news'),
  materialBuilder: (_, __) => NewsPage(),
  routes: [
    Route(
      matcher: Matcher.path('{articleId}'),
      materialBuilder: (_, result) => ArticlePage(result['articleId']),
    ),
  ],
);
