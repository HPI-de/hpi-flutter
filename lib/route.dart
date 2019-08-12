import 'package:flutter/material.dart';
import 'package:kt_dart/collection.dart';
import 'package:meta/meta.dart';

import 'app/widgets/main_scaffold.dart';
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
        if (route == news) return NewsPage();

        return MainScaffold(
          body: Center(
            child: Text(
              "Page ${route.name} is not yet implemented",
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
  static const news = const Route._internal('/news');

  static KtList<Route> values = KtList.of(dashboard, courses, news);
}
