import 'package:flutter/material.dart';
import 'package:hpi_flutter/app/app.dart';
import 'package:kt_dart/collection.dart';
import 'package:meta/meta.dart';

import 'course/widgets/course_detail_page.dart';
import 'course/widgets/course_page.dart';
import 'food/widgets/food_page.dart';
import 'main.dart';
import 'myhpi/widgets/infobit_page.dart';
import 'myhpi/widgets/myhpi_page.dart';
import 'news/widgets/article_page.dart';
import 'news/widgets/news_page.dart';
import 'onboarding/widgets/onboarding_page.dart';
import 'settings/widgets/settings_page.dart';
import 'tools/widgets/timer_page.dart';

@immutable
class Route {
  const Route._internal(this.name);
  factory Route.fromString(String name) =>
      values.firstOrNull((route) => route.name == name);

  final String name;

  static MaterialPageRoute generateRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) {
        onLocaleChanged(Localizations.localeOf(context));

        var route = Route.fromString(settings.name);
        assert(route != null,
            'Did you forget to add route ${settings.name} to Route.values?');

        if (route == dashboard) {
          return DashboardPage();
        }
        if (route == courses) {
          return CoursePage();
        }
        if (route == coursesDetail) {
          return CourseDetailPage(settings.arguments as String);
        }
        if (route == food) {
          return FoodPage();
        }
        if (route == myhpi) {
          return MyHpiPage();
        }
        if (route == myhpiInfoBit) {
          return InfoBitPage(infoBitId: settings.arguments as String);
        }
        if (route == news) {
          return NewsPage();
        }
        if (route == newsArticle) {
          return ArticlePage(settings.arguments as String);
        }
        if (route == onboarding) {
          return OnboardingPage();
        }
        if (route == tools) {
          return TimerPage();
        }
        if (route == toolsTimer) {
          return TimerPage();
        }

        if (route == Route.settings) {
          return SettingsPage();
        }
        if (route == settingsPrivacyPolicy) {
          return PrivacyPolicyPage();
        }

        return MainScaffold(
          body: Center(
            child: Text(
              'Page ${route?.name} is not yet implemented',
              style: context.theme.textTheme.headline
                  .copyWith(color: context.theme.errorColor),
            ),
          ),
        );
      },
      settings: settings,
    );
  }

  @override
  String toString() => 'Routes.$name';

  static const dashboard = Route._internal('/');
  static const courses = Route._internal('/courses');
  static const coursesDetail = Route._internal('/courses/courseId');
  static const food = Route._internal('/food');
  static const myhpi = Route._internal('/myhpi');
  static const myhpiInfoBit = Route._internal('/myhpi/infoBitId');
  static const news = Route._internal('/news');
  static const newsArticle = Route._internal('/news/articleId');
  // We don't want onboarding to be understood as a deep link which would push
  // the dashboard page in the stack for first time users. Hence no '/'-prefix.
  static const onboarding = Route._internal('onboarding');
  static const tools = Route._internal('/tools');
  static const toolsTimer = Route._internal('/tools/timer');

  static const settings = Route._internal('/settings');
  static const settingsPrivacyPolicy =
      Route._internal('/settings/privacyPolicy');

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
