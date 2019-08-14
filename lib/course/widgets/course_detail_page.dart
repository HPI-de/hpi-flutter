import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:grpc/grpc.dart';
import 'package:hpi_flutter/core/utils.dart';
import 'package:hpi_flutter/course/bloc.dart';
import 'package:hpi_flutter/course/data/course.dart';
import 'package:hpi_flutter/course/widgets/elevated_expansion_tile.dart';
import 'package:kt_dart/collection.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils.dart';

@immutable
class CourseDetailPage extends StatelessWidget {
  final Course course;

  CourseDetailPage(this.course) : assert(course != null);

  @override
  Widget build(BuildContext context) {
    return ProxyProvider<ClientChannel, CourseBloc>(
      builder: (_, clientChannel, __) => CourseBloc(clientChannel),
      child: Builder(
        builder: (context) => _buildScaffold(context),
      ),
    );
  }

  Widget _buildScaffold(BuildContext context) {
    assert(context != null);

    var bloc = Provider.of<CourseBloc>(context);
    var stream = Observable.combineLatest2(
        bloc.getCourseSeries(course.courseSeriesId),
        bloc.getCourseDetail(course.id),
        (series, detail) => KtPair<CourseSeries, CourseDetail>(series, detail));
    return StreamBuilder<KtPair<CourseSeries, CourseDetail>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasError)
          return Center(child: Text(snapshot.error.toString()));
        if (!snapshot.hasData) return Placeholder();

        return Scaffold(
          appBar: AppBar(
            title: Text(snapshot.data.first.title),
          ),
          body: ListView(
            children: _buildCourseDetails(
              context,
              course: course,
              courseSeries: snapshot.data.first,
              courseDetail: snapshot.data.second,
            ),
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
        leading: Icons.info_outline,
        title:
            "${courseSeries.ects} ECTS · ${courseSeries.hoursPerWeek} h/week",
        subtitle: courseSeries.types
            .map((t) => courseTypeToString(t))
            .joinToString(separator: ' · '),
      ),
      if (courseDetail.teletask != null)
        _buildElevatedTile(
          context,
          leading: Icons.videocam,
          title: "This course is on tele-TASK",
          trailing: Icons.open_in_new,
          onTap: () async {
            if (await canLaunch(courseDetail.teletask))
              await launch(courseDetail.teletask);
          },
        ),
      _buildElevatedTile(
        context,
        leading: Icons.person_outline,
        title: course.lecturer,
        subtitle: course.assistants.joinToString(),
      ),
      _buildElevatedTile(
        context,
        leading: Icons.language,
        title: getLanguage(courseSeries.language),
      ),
      _buildElevatedTile(
        context,
        leading: Icons.view_module,
        title: "Programs & Modules",
        subtitle: courseDetail.programs
            .map((program) =>
                program.key +
                "\v" +
                program.value
                    .joinToString(separator: '\n', transform: (v) => "\t\t\t\t$v"))
            .joinToString(separator: "\n"),
      ),
      _buildCourseInfoTile(
          context, Icons.subject, "Description", courseDetail.description),
      _buildCourseInfoTile(
          context, Icons.check, "Requirements", courseDetail.requirements),
      _buildCourseInfoTile(
          context, Icons.school, "Learning", courseDetail.learning),
      _buildCourseInfoTile(context, Icons.format_list_numbered, "Examination",
          courseDetail.examination),
      _buildCourseInfoTile(
          context, Icons.calendar_today, "Dates", courseDetail.dates),
      _buildCourseInfoTile(
          context, Icons.book, "Literature", courseDetail.literature),
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
      child: InkWell(
        onTap: onTap,
        child: ListTile(
          leading: leading != null ? Icon(leading) : null,
          title: title != null ? Text(title) : null,
          subtitle: subtitle != null ? Text(subtitle) : null,
          trailing: trailing != null ? Icon(trailing) : null,
        ),
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
