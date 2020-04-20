import 'package:flutter_deep_linking/flutter_deep_linking.dart';

import 'widgets/course_detail_page.dart';
import 'widgets/course_page.dart';

final courseRoutes = Route(
  matcher: Matcher.path('courses'),
  materialBuilder: (_, __) => CoursePage(),
  routes: [
    Route(
      matcher: Matcher.path('{courseId}'),
      materialBuilder: (_, result) => CourseDetailPage(result['courseId']),
    ),
  ],
);
