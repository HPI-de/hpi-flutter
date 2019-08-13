import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:grpc/grpc.dart';
import 'package:hpi_flutter/course/bloc.dart';
import 'package:hpi_flutter/course/data/course.dart';
import 'package:hpi_flutter/course/widgets/elevated_expansion_tile.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils.dart';

@immutable
class CourseDetailPage extends StatelessWidget {
  final Course course;

  CourseDetailPage(this.course) : assert(course != null);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CourseSeries>(
      stream: CourseBloc(Provider.of<ClientChannel>(context))
          .getCourseSeries(course.courseSeriesId),
      builder: (context, snapshot) {
        if (snapshot.hasError)
          return Center(
            child: Text(snapshot.error.toString()),
          );
        if (!snapshot.hasData) return Placeholder();

        var courseSeries = snapshot.data;
        return StreamBuilder<CourseDetail>(
            stream: CourseBloc(Provider.of<ClientChannel>(context))
                .getCourseDetail(course.id),
            builder: (context, snapshot) {
              if (snapshot.hasError)
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              if (!snapshot.hasData) return Placeholder();

              var courseDetail = snapshot.data;
              return Scaffold(
                backgroundColor: Color(0xfffafafa),
                appBar: AppBar(
                  title: Text(courseSeries.title),
                ),
                body: ListView(
                    children: _buildCourseDetails(
                  course: course,
                  courseSeries: courseSeries,
                  courseDetail: courseDetail,
                )),
              );
            });
      },
    );
  }

  List<Widget> _buildCourseDetails(
      {Course course, CourseSeries courseSeries, CourseDetail courseDetail}) {
    return [
      Material(
        elevation: 1.0,
        color: Colors.white,
        child: ListTile(
          title: Text(
              '''${courseSeries.ects} ECTS · ${courseSeries.hoursPerWeek} h/week'''),
          subtitle: Text(courseSeries.types
              .map((t) => courseTypeToString(t))
              .joinToString(separator: ' · ')),
          leading: Icon(Icons.info_outline),
        ),
      ),
      Material(
        elevation: 1.0,
        color: Colors.white,
        child: ListTile(
          title: Text(getLanguage(courseSeries.language)),
          leading: Icon(Icons.language),
        ),
      ),
      if (courseDetail.teletask != null)
        Material(
          elevation: 1.0,
          color: Colors.white,
          child: ListTile(
            title: Text('This course is on tele-TASK'),
            leading: Icon(Icons.videocam),
            trailing: IconButton(
              icon: Icon(Icons.open_in_new),
              onPressed: () async {
                if (await canLaunch(courseDetail.teletask))
                  await launch(courseDetail.teletask);
              },
            ),
          ),
        ),
      Material(
        elevation: 1.0,
        color: Colors.white,
        child: ListTile(
          title: Text(course.lecturer),
          subtitle: Text(course.assistants.joinToString(separator: ', ')),
          leading: Icon(Icons.person_outline),
        ),
      ),
      ElevatedExpansionTile(
        title: Text('Programs & Modules'),
        children: courseDetail.programs
            .map((program) => ListTile(
                title: Text(program.key),
                subtitle:
                    Text(program.value.programs.joinToString(separator: '\n'))))
            .asList(),
        leading: Icon(Icons.grid_on),
      ),
      if (courseDetail.description.isNotEmpty)
        CourseInformationTile(
          title: 'Description',
          content: courseDetail.description,
          icon: Icon(Icons.subject),
        ),
      if (courseDetail.requirements.isNotEmpty)
        CourseInformationTile(
          title: 'Requirements',
          content: courseDetail.requirements,
          icon: Icon(Icons.check),
        ),
      if (courseDetail.learning.isNotEmpty)
        CourseInformationTile(
          title: 'Learning',
          content: courseDetail.learning,
          icon: Icon(Icons.school),
        ),
      if (courseDetail.examination.isNotEmpty)
        CourseInformationTile(
          title: 'Examination',
          content: courseDetail.examination,
          icon: Icon(Icons.format_list_numbered),
        ),
      if (courseDetail.dates.isNotEmpty)
        CourseInformationTile(
          title: 'Dates',
          content: courseDetail.dates,
          icon: Icon(Icons.calendar_today),
        ),
      if (courseDetail.literature.isNotEmpty)
        CourseInformationTile(
          title: 'Literature',
          content: courseDetail.literature,
          icon: Icon(Icons.book),
        ),
      SizedBox(height: 16),
      Text(
        'All statements without guarantee',
        textAlign: TextAlign.center,
      ),
      SizedBox(height: 16)
    ];
  }
}

class CourseInformationTile extends StatelessWidget {
  final String title;
  final String content;
  final Icon icon;

  const CourseInformationTile({Key key, this.title, this.content, this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedExpansionTile(
      title: Text(title),
      leading: icon,
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
