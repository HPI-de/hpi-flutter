import 'package:flutter/material.dart' hide Route;
import 'package:hpi_flutter/app/app.dart';
import 'package:hpi_flutter/app/widgets/app_bar.dart';
import 'package:hpi_flutter/app/widgets/main_scaffold.dart';
import 'package:hpi_flutter/core/localizations.dart';
import 'package:hpi_flutter/core/widgets/pagination.dart';
import 'package:hpi_flutter/core/widgets/utils.dart';
import 'package:hpi_flutter/course/data/bloc.dart';
import 'package:hpi_flutter/route.dart';
import 'package:kt_dart/collection.dart';
import 'package:outline_material_icons/outline_material_icons.dart';

import '../data/course.dart';
import '../utils.dart';

@immutable
class CoursePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              child: HpiSliverAppBar(
                floating: true,
                pinned: true,
                forceElevated: innerBoxIsScrolled,
                title: Text(HpiL11n.get(context, 'course')),
                bottom: TabBar(
                  indicatorColor: Theme.of(context).primaryColor,
                  labelColor: Theme.of(context).primaryColor,
                  unselectedLabelColor:
                      Theme.of(context).textTheme.body2.color.withOpacity(0.7),
                  tabs: [
                    Tab(text: HpiL11n.get(context, 'course/tab.current')),
                    Tab(text: HpiL11n.get(context, 'course/tab.all')),
                  ],
                ),
              ),
            )
          ],
          body: TabBarView(
            children: KtList.from([
              KtPair('tab:course', CourseList()),
              KtPair('tab:courseSeries', CourseSeriesList()),
            ])
                .mapIndexed((index, tab) => SafeArea(
                      top: false,
                      bottom: false,
                      child: Builder(
                        builder: (context) => CustomScrollView(
                          key: PageStorageKey(tab.first),
                          slivers: <Widget>[
                            SliverOverlapInjector(
                              handle: NestedScrollView
                                  .sliverOverlapAbsorberHandleFor(context),
                            ),
                            tab.second,
                          ],
                        ),
                      ),
                    ))
                .asList(),
          ),
        ),
      ),
    );
  }
}

class CourseList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PaginatedSliverList<Course>(
      dataLoader: services.get<CourseBloc>().getCourses,
      itemBuilder: (context, course, __) => Builder(
        builder: (context) => StreamBuilder<CourseSeries>(
          stream:
              services.get<CourseBloc>().getCourseSeries(course.courseSeriesId),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return ListTile(
                title: Text(snapshot.error?.toString() ??
                    HpiL11n.get(context, 'loading')),
              );
            }

            return ListTile(
              title: Text(snapshot.data.title),
              subtitle: Text(
                course.lecturers.joinToString(),
                maxLines: 1,
              ),
              onTap: () {
                Navigator.of(context)
                    .pushNamed(Route.coursesDetail.name, arguments: course.id);
              },
            );
          },
        ),
      ),
    );
  }
}

class CourseSeriesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PaginatedSliverList<CourseSeries>(
      dataLoader: services.get<CourseBloc>().getAllCourseSeries,
      itemBuilder: (context, courseSeries, __) => ExpansionTile(
        key: PageStorageKey(courseSeries.id),
        title: Text(courseSeries.title),
        children: <Widget>[
          ListTile(
            leading: Icon(OMIcons.info),
            title: Text(
              HpiL11n.get(
                context,
                'course/course.details',
                args: [courseSeries.ects ?? 0, courseSeries.hoursPerWeek],
              ),
            ),
            subtitle: Text(courseSeries.types
                .map((t) => courseTypeToString(context, t))
                .joinToString(separator: ' · ')),
          ),
          ListTile(
            leading: Icon(OMIcons.language),
            title: Text(getLanguage(context, courseSeries.language)),
          ),
        ],
      ),
    );
  }
}
