import 'package:flutter/material.dart' hide Route;
import 'package:hpi_flutter/app/app.dart';
import 'package:hpi_flutter/core/core.dart';
import 'package:hpi_flutter/route.dart';
import 'package:kt_dart/collection.dart';
import 'package:outline_material_icons/outline_material_icons.dart';

import '../bloc.dart';
import '../data.dart';
import '../utils.dart';

class CoursePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final s = context.s;

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
                title: Text(s.course),
                bottom: TabBar(
                  indicatorColor: context.theme.primaryColor,
                  labelColor: context.theme.primaryColor,
                  unselectedLabelColor:
                      context.theme.textTheme.body2.color.withOpacity(0.7),
                  tabs: [
                    Tab(text: s.course_tab_current),
                    Tab(text: s.course_tab_all),
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
                title: Text(
                    snapshot.error?.toString() ?? context.s.general_loading),
              );
            }

            return ListTile(
              title: Text(snapshot.data.title),
              subtitle: Text(
                course.lecturers.joinToString(),
                maxLines: 1,
              ),
              onTap: () {
                context.navigator
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
    final s = context.s;

    return PaginatedSliverList<CourseSeries>(
      dataLoader: services.get<CourseBloc>().getAllCourseSeries,
      itemBuilder: (context, courseSeries, __) => ExpansionTile(
        key: PageStorageKey(courseSeries.id),
        title: Text(courseSeries.title),
        children: <Widget>[
          ListTile(
            leading: Icon(OMIcons.info),
            title: Text(
              s.course_course_details(
                  courseSeries.ects, courseSeries.hoursPerWeek),
            ),
            subtitle: Text(
              courseSeries.types.joinToString(
                separator: ' · ',
                transform: s.course_course_type,
              ),
            ),
          ),
          ListTile(
            leading: Icon(OMIcons.language),
            title: Text(context.s.general_language(courseSeries.language)),
          ),
        ],
      ),
    );
  }
}
