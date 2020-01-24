import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hpi_flutter/app/widgets/app_bar.dart';
import 'package:hpi_flutter/app/widgets/main_scaffold.dart';
import 'package:hpi_flutter/app/widgets/utils.dart';
import 'package:hpi_flutter/core/localizations.dart';
import 'package:hpi_flutter/core/utils.dart';
import 'package:hpi_flutter/core/widgets/utils.dart';
import 'package:hpi_flutter/course/data/bloc.dart';
import 'package:hpi_flutter/course/data/course.dart';
import 'package:hpi_flutter/feedback/widgets/feedback_dialog.dart';
import 'package:kt_dart/collection.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:share/share.dart';

import '../utils.dart';
import 'elevated_expansion_tile.dart';

@immutable
class CourseDetailPage extends StatelessWidget {
  CourseDetailPage(this.courseId) : assert(courseId != null);

  final String courseId;

  @override
  Widget build(BuildContext context) {
    return ProxyProvider<Uri, CourseBloc>(
      update: (_, serverUrl, __) =>
          CourseBloc(serverUrl, Localizations.localeOf(context)),
      child: Builder(
        builder: (context) => _buildScaffold(context),
      ),
    );
  }

  Widget _buildScaffold(BuildContext context) {
    assert(context != null);

    var bloc = Provider.of<CourseBloc>(context);
    var stream = Observable.combineLatest2<KtPair<Course, CourseSeries>,
        CourseDetail, KtTriple<Course, CourseSeries, CourseDetail>>(
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
        if (!snapshot.hasData) {
          return buildLoadingErrorScaffold(
            context,
            snapshot,
            appBarElevated: true,
            loadingTitle: HpiL11n.get(context, 'course/course.loading'),
          );
        }

        var course = snapshot.data.first;
        var courseSeries = snapshot.data.second;
        var courseDetail = snapshot.data.third;

        return MainScaffold(
          bottomActions: KtList.from([
            IconButton(
              icon: Icon(OMIcons.share),
              onPressed: () {
                Share.share(course.website);
              },
            )
          ]),
          menuItemHandler: (value) async {
            switch (value as String) {
              case 'openInBrowser':
                await tryLaunch(course.website);
                break;
              default:
                assert(false);
                break;
            }
          },
          menuItems: KtList.from([
            PopupMenuItem(
                value: 'openInBrowser',
                child: HpiL11n.text(context, 'openInBrowser')),
          ]),
          body: CustomScrollView(
            slivers: <Widget>[
              HpiSliverAppBar(
                floating: true,
                backgroundColor: Theme.of(context).cardColor,
                title: buildAppBarTitle(
                  context: context,
                  title: Text(courseSeries.title),
                  subtitle: StreamBuilder<Semester>(
                    stream: bloc.getSemester(course.semesterId),
                    builder: (context, snapshot) => Text(
                      snapshot.data != null
                          ? semesterToString(context, snapshot.data)
                          : course.semesterId,
                    ),
                  ),
                ),
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

  List<Widget> _buildCourseDetails(BuildContext context,
      {Course course, CourseSeries courseSeries, CourseDetail courseDetail}) {
    assert(context != null);

    return [
      _buildElevatedTile(
        context,
        leading: OMIcons.info,
        title: HpiL11n.get(
          context,
          'course/course.details',
          args: [courseSeries.ects, courseSeries.hoursPerWeek],
        ),
        subtitle: courseSeries.types
            .toList()
            .sortedBy<num>((t) => t.index)
            .joinToString(
              separator: ' · ',
              transform: (t) => courseTypeToString(context, t),
            ),
      ),
      if (courseDetail.teletask != null)
        _buildElevatedTile(
          context,
          leading: OMIcons.videocam,
          title: HpiL11n.of(context)('course/course.teleTask'),
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
        title: getLanguage(context, courseSeries.language),
      ),
      _buildElevatedTile(
        context,
        leading: OMIcons.viewModule,
        title: HpiL11n.get(context, 'course/course.programsModules'),
        subtitle: buildProgramInfo(courseDetail),
      ),
      _buildCourseInfoTile(
          context, OMIcons.subject, 'description', courseDetail.description),
      _buildCourseInfoTile(
          context, OMIcons.check, 'requirements', courseDetail.requirements),
      _buildCourseInfoTile(
          context, OMIcons.school, 'learning', courseDetail.learning),
      _buildCourseInfoTile(context, OMIcons.formatListNumbered, 'examination',
          courseDetail.examination),
      _buildCourseInfoTile(
          context, OMIcons.calendarToday, 'dates', courseDetail.dates),
      _buildCourseInfoTile(
          context, OMIcons.book, 'literature', courseDetail.literature),
      SizedBox(height: 16),
      Text(
        HpiL11n.get(context, 'course/course.noGuarantee'),
        style: Theme.of(context)
            .textTheme
            .body1
            .copyWith(color: Colors.black.withOpacity(0.6)),
        textAlign: TextAlign.center,
      ),
      Center(
        child: FlatButton(
          child: Text(HpiL11n.get(context, 'course/course.reportError')),
          onPressed: () => FeedbackDialog.show(
            context,
            title: HpiL11n.get(context, 'course/course.reportError'),
            feedbackType: 'course.data.error',
          ),
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
    BuildContext context,
    IconData icon,
    String titleKey,
    String content,
  ) {
    assert(context != null);
    assert(IconData != null);
    assert(titleKey != null);

    if (isNullOrBlank(content)) return null;
    return ElevatedExpansionTile(
      leading: Icon(icon),
      title: Text(
        HpiL11n.get(context, 'course/course.$titleKey'),
        style: Theme.of(context).textTheme.subhead,
      ),
      children: [
        Html(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          data: content,
          onLinkTap: tryLaunch,
        )
      ],
    );
  }
}
