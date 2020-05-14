import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hpi_flutter/app/app.dart';
import 'package:hpi_flutter/core/core.dart';
import 'package:hpi_flutter/feedback/feedback.dart';
import 'package:kt_dart/kt.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:rxdart/rxdart.dart';
import 'package:share/share.dart';

import '../bloc.dart';
import '../data.dart';
import '../utils.dart';
import 'elevated_expansion_tile.dart';

class CourseDetailPage extends StatelessWidget {
  const CourseDetailPage(this.courseId) : assert(courseId != null);

  final String courseId;

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final bloc = services.get<CourseBloc>();
    final stream = Rx.combineLatest2<KtPair<Course, CourseSeries>, CourseDetail,
        KtTriple<Course, CourseSeries, CourseDetail>>(
      bloc.getCourse(courseId).switchMap(
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
        if (!snapshot.hasData) {
          return buildLoadingErrorScaffold(
            context,
            snapshot,
            appBarElevated: true,
            loadingTitle: s.course_course_loading,
          );
        }

        final course = snapshot.data.first;
        final courseSeries = snapshot.data.second;
        final courseDetail = snapshot.data.third;

        return MainScaffold(
          body: CustomScrollView(
            slivers: <Widget>[
              HpiSliverAppBar(
                floating: true,
                backgroundColor: context.theme.cardColor,
                title: buildAppBarTitle(
                  context: context,
                  title: Text(courseSeries.title),
                  subtitle: StreamBuilder<Semester>(
                    stream: bloc.getSemester(course.semesterId),
                    builder: (context, snapshot) {
                      final semester = snapshot.data;

                      return Text(
                        semester != null
                            ? s.course_semester(semester.term, semester.year)
                            : course.semesterId,
                      );
                    },
                  ),
                ),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(OMIcons.share),
                    onPressed: () => Share.share(course.website),
                  ),
                ],
                overflowActions: [
                  PopupMenuItem(
                    value: 'openInBrowser',
                    child: Text(s.general_openInBrowser),
                  ),
                ],
                overflowActionHandler: (value) async {
                  if (value == 'openInBrowser') {
                    await tryLaunch(course.website);
                  }
                },
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  _buildCourseDetails(
                    context,
                    course: course,
                    courseSeries: courseSeries,
                    courseDetail: courseDetail,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildCourseDetails(
    BuildContext context, {
    @required Course course,
    @required CourseSeries courseSeries,
    @required CourseDetail courseDetail,
  }) {
    assert(context != null);
    assert(course != null);
    assert(courseSeries != null);
    assert(courseDetail != null);

    final s = context.s;
    return [
      _buildElevatedTile(
        context,
        leading: OMIcons.info,
        title: s.course_course_details(
            courseSeries.ects, courseSeries.hoursPerWeek),
        subtitle: courseSeries.types
            .sortedBy((t) => t.index)
            .joinToString(separator: ' · ', transform: s.course_course_type),
      ),
      if (courseDetail.teletask != null)
        _buildElevatedTile(
          context,
          leading: OMIcons.videocam,
          title: s.course_course_teleTask,
          trailing: OMIcons.openInNew,
          onTap: () async {
            await tryLaunch(courseDetail.teletask);
          },
        ),
      _buildElevatedTile(
        context,
        leading: OMIcons.personOutline,
        title: course.lecturers.joinToString(),
        subtitle: course.assistants.joinToString(),
      ),
      _buildElevatedTile(
        context,
        leading: OMIcons.language,
        title: context.s.general_language(courseSeries.language),
      ),
      _buildElevatedTile(
        context,
        leading: OMIcons.viewModule,
        title: s.course_course_programsModules,
        subtitle: buildProgramInfo(courseDetail),
      ),
      _buildCourseInfoTile(context, OMIcons.subject,
          context.s.course_course_description, courseDetail.description),
      _buildCourseInfoTile(context, OMIcons.check,
          context.s.course_course_requirements, courseDetail.requirements),
      _buildCourseInfoTile(context, OMIcons.school,
          context.s.course_course_learning, courseDetail.learning),
      _buildCourseInfoTile(context, OMIcons.formatListNumbered,
          context.s.course_course_examination, courseDetail.examination),
      _buildCourseInfoTile(context, OMIcons.calendarToday,
          context.s.course_course_dates, courseDetail.dates),
      _buildCourseInfoTile(context, OMIcons.book,
          context.s.course_course_literature, courseDetail.literature),
      SizedBox(height: 16),
      Text(
        s.course_course_noGuarantee,
        style: context.textTheme.bodyText2
            .copyWith(color: Colors.black.withOpacity(0.6)),
        textAlign: TextAlign.center,
      ),
      Center(
        child: FlatButton(
          onPressed: () => FeedbackDialog.show(
            context,
            title: s.course_course_reportError,
            feedbackType: 'course.data.error',
          ),
          child: Text(s.course_course_reportError),
        ),
      ),
      SizedBox(height: 16)
    ].where((w) => w != null).toList();
  }

  Widget _buildElevatedTile(
    BuildContext context, {
    IconData leading,
    String title,
    String subtitle,
    IconData trailing,
    VoidCallback onTap,
  }) {
    assert(context != null);

    return Material(
      color: context.theme.cardColor,
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
    BuildContext context,
    IconData icon,
    String title,
    String content,
  ) {
    assert(context != null);
    assert(IconData != null);
    assert(title != null);

    if (isNullOrBlank(content)) {
      return null;
    }
    return ElevatedExpansionTile(
      leading: Icon(icon),
      title: Text(title, style: context.textTheme.subtitle1),
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Html(
            data: content,
            onLinkTap: tryLaunch,
          ),
        ),
      ],
    );
  }
}
