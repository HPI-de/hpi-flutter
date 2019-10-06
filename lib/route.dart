import 'package:flutter/material.dart';
import 'package:kt_dart/collection.dart';
import 'package:meta/meta.dart';

import 'app/widgets/dashboard_page.dart';
import 'app/widgets/main_scaffold.dart';
import 'course/widgets/course_detail_page.dart';
import 'course/widgets/course_page.dart';
import 'food/widgets/food_page.dart';
import 'myhpi/widgets/infobit_page.dart';
import 'myhpi/widgets/myhpi_page.dart';
import 'news/widgets/article_page.dart';
import 'news/widgets/news_page.dart';
import 'onboarding/widgets/onboarding_page.dart';
import 'settings/widgets/settings_page.dart';
import 'tools/widgets/timer_page.dart';

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
        if (route == food) return FoodPage();
        if (route == myhpi) return MyHpiPage();
        if (route == myhpiInfoBit)
          return InfoBitPage(infoBitId: settings.arguments as String);
        if (route == news) return NewsPage();
        if (route == newsArticle)
          return ArticlePage(settings.arguments as String);
        if (route == onboarding) return OnboardingPage();
        if (route == tools) return TimerPage();
        if (route == toolsTimer) return TimerPage();

        if (route == Route.settings) return SettingsPage();
        if (route == settingsPrivacyPolicy) return PrivacyPolicyPage();

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
  static const food = const Route._internal('/food');
  static const myhpi = const Route._internal('/myhpi');
  static const myhpiInfoBit = const Route._internal('/myhpi/infoBitId');
  static const news = const Route._internal('/news');
  static const newsArticle = const Route._internal('/news/articleId');
  static const onboarding = const Route._internal('onboarding');
  static const tools = const Route._internal('/tools');
  static const toolsTimer = const Route._internal('/tools/timer');

  static const settings = const Route._internal('/settings');
  static const settingsPrivacyPolicy =
      const Route._internal('/settings/privacyPolicy');

  static KtList<Route> values = KtList.from([
    dashboard,
    courses,
    coursesDetail,
    food,
    myhpi,
    myhpiInfoBit,
    news,
    newsArticle,
    onboarding,
    tools,
    toolsTimer,
    settings,
    settingsPrivacyPolicy,
  ]);
}
