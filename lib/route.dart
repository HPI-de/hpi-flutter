import 'package:flutter/material.dart';
import 'package:hpi_flutter/course/widgets/course_page.dart';
import 'package:hpi_flutter/food/widgets/food_page.dart';
import 'package:hpi_flutter/myhpi/widgets/myhpi_page.dart';
import 'package:kt_dart/collection.dart';
import 'package:meta/meta.dart';

import 'app/widgets/dashboard_page.dart';
import 'app/widgets/main_scaffold.dart';
import 'course/widgets/course_detail_page.dart';
import 'news/widgets/article_page.dart';
import 'news/widgets/news_page.dart';

@immutable
class Route {
  final String name;

  const Route._internal(this.name);
  factory Route.fromString(String name) =>
      values.firstOrNull((route) => route.name == name);

  static MaterialPageRoute generateRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) {
        var route = Route.fromString(settings.name);
        assert(route != null,
            "Did you forget to add route ${settings.name} to Route.values?");
        if (route == dashboard) return DashboardPage();
        if (route == courses) return CoursePage();
        if (route == coursesDetail)
          return CourseDetailPage(settings.arguments as String);
        if (route == myhpi) return MyHpiPage();
        if (route == news) return NewsPage();
        if (route == newsArticle)
          return ArticlePage(settings.arguments as String);
        if (route == food) return FoodPage();

        return MainScaffold(
          body: Center(
            child: Text(
              "Page ${route?.name} is not yet implemented",
              style: Theme.of(context)
                  .textTheme
                  .headline
                  .copyWith(color: Theme.of(context).errorColor),
            ),
          ),
        );
      },
      settings: settings,
    );
  }

  toString() => 'Routes.$name';

  static const dashboard = const Route._internal('/');
  static const courses = const Route._internal('/courses');
  static const coursesDetail = const Route._internal('/courses/courseId');
  static const myhpi = const Route._internal('/myhpi');
  static const news = const Route._internal('/news');
  static const newsArticle = const Route._internal('/news/articleId');
  static const food = const Route._internal('/food');

  static KtList<Route> values = KtList.of(
      dashboard, courses, coursesDetail, myhpi, news, newsArticle, food);
}
