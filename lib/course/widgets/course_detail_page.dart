import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hpi_flutter/app/widgets/main_scaffold.dart';
import 'package:hpi_flutter/app/widgets/utils.dart';
import 'package:hpi_flutter/core/utils.dart';
import 'package:hpi_flutter/course/data/bloc.dart';
import 'package:hpi_flutter/course/data/course.dart';
import 'package:kt_dart/collection.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils.dart';
import 'elevated_expansion_tile.dart';

@immutable
class CourseDetailPage extends StatelessWidget {
  CourseDetailPage(this.courseId) : assert(courseId != null);

  final String courseId;

  @override
  Widget build(BuildContext context) {
    return ProxyProvider<Uri, CourseBloc>(
      builder: (_, serverUrl, __) => CourseBloc(serverUrl),
      child: Builder(
        builder: (context) => _buildScaffold(context),
      ),
    );
  }

  Widget _buildScaffold(BuildContext context) {
    assert(context != null);

    var bloc = Provider.of<CourseBloc>(context);
    var stream = Observable.combineLatest2(
      Observable(bloc.getCourse(courseId)).switchMap(
        (c) => bloc
            .getCourseSeries(c.courseSeriesId)
            .map((cs) => KtPair<Course, CourseSeries>(c, cs)),
      ),
      bloc.getCourseDetail(courseId),
      (ccs, detail) => KtTriple<Course, CourseSeries, CourseDetail>(
          ccs.first, ccs.second, detail),
    );

    return StreamBuilder<KtTriple<Course, CourseSeries, CourseDetail>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasError)
          return Center(child: Text(snapshot.error.toString()));
        if (!snapshot.hasData) return Placeholder();

        var course = snapshot.data.first;
        var courseSeries = snapshot.data.second;
        var courseDetail = snapshot.data.third;

        return MainScaffold(
          body: ListView(
            children: <Widget>[
              AppBar(
                title: buildAppBarTitle(
                  title: Text(courseSeries.title),
                  subtitle: StreamBuilder<Semester>(
                    stream: bloc.getSemester(course.semesterId),
                    builder: (context, snapshot) => Text(
                      snapshot.data != null
                          ? semesterToString(snapshot.data)
                          : course.semesterId,
                      style: Theme.of(context).textTheme.subtitle,
                    ),
                  ),
                ),
              ),
              ..._buildCourseDetails(
                context,
                course: course,
                courseSeries: courseSeries,
                courseDetail: courseDetail,
              ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildCourseDetails(BuildContext context,
      {Course course, CourseSeries courseSeries, CourseDetail courseDetail}) {
    assert(context != null);

    return [
      _buildElevatedTile(
        context,
        leading: OMIcons.info,
        title:
            '${courseSeries.ects} ECTS · ${courseSeries.hoursPerWeek} h/week',
        subtitle: courseSeries.types
            .map((t) => courseTypeToString(t))
            .joinToString(separator: ' · '),
      ),
      if (courseDetail.teletask != null)
        _buildElevatedTile(
          context,
          leading: OMIcons.videocam,
          title: 'This course is on tele-TASK',
          trailing: OMIcons.openInNew,
          onTap: () async {
            if (await canLaunch(courseDetail.teletask))
              await launch(courseDetail.teletask);
          },
        ),
      _buildElevatedTile(
        context,
        leading: OMIcons.personOutline,
        title: course.lecturer,
        subtitle: course.assistants.joinToString(),
      ),
      _buildElevatedTile(
        context,
        leading: OMIcons.language,
        title: getLanguage(courseSeries.language),
      ),
      _buildElevatedTile(
        context,
        leading: OMIcons.viewModule,
        title: 'Programs & Modules',
        subtitle: courseDetail.programs
            .map((program) =>
                program.key +
                '\v' +
                program.value.joinToString(
                  separator: '\n',
                  transform: (v) => '\t\t\t\t$v',
                ))
            .joinToString(separator: '\n'),
      ),
      _buildCourseInfoTile(
          context, OMIcons.subject, 'Description', courseDetail.description),
      _buildCourseInfoTile(
          context, OMIcons.check, 'Requirements', courseDetail.requirements),
      _buildCourseInfoTile(
          context, OMIcons.school, 'Learning', courseDetail.learning),
      _buildCourseInfoTile(context, OMIcons.formatListNumbered, 'Examination',
          courseDetail.examination),
      _buildCourseInfoTile(
          context, OMIcons.calendarToday, 'Dates', courseDetail.dates),
      _buildCourseInfoTile(
          context, OMIcons.book, 'Literature', courseDetail.literature),
      SizedBox(height: 16),
      Text(
        'All statements without guarantee',
        style: Theme.of(context)
            .textTheme
            .body1
            .copyWith(color: Colors.black.withOpacity(0.6)),
        textAlign: TextAlign.center,
      ),
      SizedBox(height: 16)
    ].where((w) => w != null).toList();
  }

  Widget _buildElevatedTile(BuildContext context,
      {IconData leading,
      String title,
      String subtitle,
      IconData trailing,
      Function onTap}) {
    assert(context != null);

    return Material(
      color: Theme.of(context).cardColor,
      child: ListTile(
        leading: leading != null ? Icon(leading) : null,
        title: title != null ? Text(title) : null,
        subtitle: subtitle != null ? Text(subtitle) : null,
        trailing: trailing != null ? Icon(trailing) : null,
        onTap: onTap,
      ),
    );
  }

  Widget _buildCourseInfoTile(
      BuildContext context, IconData icon, String title, String content) {
    assert(context != null);
    assert(IconData != null);
    assert(title != null);

    if (isNullOrBlank(content)) return null;
    return ElevatedExpansionTile(
      leading: Icon(icon),
      title: Text(
        title,
        style: Theme.of(context).textTheme.subhead,
      ),
      children: [
        Html(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          data: content,
          onLinkTap: (url) async {
            if (await canLaunch(url)) await launch(url);
          },
        )
      ],
    );
  }
}
