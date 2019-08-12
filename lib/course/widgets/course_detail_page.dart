import 'package:flutter/material.dart';
import 'package:grpc/grpc.dart';
import 'package:hpi_flutter/course/bloc.dart';
import 'package:hpi_flutter/course/data/course.dart';
import 'package:provider/provider.dart';

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
            child: Text(snapshot.error),
          );
        if (!snapshot.hasData) return Placeholder();

        var courseSeries = snapshot.data;
        return StreamBuilder<CourseDetail>(
            stream: CourseBloc(Provider.of<ClientChannel>(context))
                .getCourseDetail(course.id),
            builder: (context, snapshot) {
              if (snapshot.hasError)
                return Center(
                  child: Text(snapshot.error),
                );
              if (!snapshot.hasData) return Placeholder();

              var courseDetail = snapshot.data;
              return Scaffold(
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
      ListTile(
        title: Text(
            '''${(courseSeries.mandatory) ? "Compulsory module" : "Voluntary module"} · 
                      ${courseSeries.ects} ECTS · ${courseSeries.hoursPerWeek} h/week'''),
        subtitle: Text(courseSeries.types.joinToString(separator: ' · ')),
        leading: Icon(Icons.info_outline),
      ),
      ListTile(
        title: Text(courseSeries.language),
        leading: Icon(Icons.language),
      ),
      ListTile(
        title: Text(course.lecturer),
        subtitle: Text(course.assistants.joinToString(separator: ', ')),
        leading: Icon(Icons.person_outline),
      ),
      ExpansionTile(
        title: Text('Description'),
        children: [Text(courseDetail.description)],
        leading: Icon(Icons.subject),
      ),
      ExpansionTile(
        title: Text('Requirements'),
        children: [Text(courseDetail.requirements)],
        leading: Icon(Icons.check),
      ),
      ExpansionTile(
        title: Text('Learning'),
        children: [Text(courseDetail.learning)],
        leading: Icon(Icons.school),
      ),
      ExpansionTile(
        title: Text('Examination'),
        children: [Text(courseDetail.examination)],
        leading: Icon(Icons.format_list_numbered),
      ),
      ExpansionTile(
        title: Text('Dates'),
        children: [Text(courseDetail.dates)],
        leading: Icon(Icons.calendar_today),
      ),
      ExpansionTile(
        title: Text('Literature'),
        children: [Text(courseDetail.literature)],
        leading: Icon(Icons.book),
      )
    ];
  }
}
