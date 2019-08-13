import 'package:flutter/material.dart';
import 'package:grpc/grpc.dart';
import 'package:hpi_flutter/course/widgets/course_detail_page.dart';
import '../data/course.dart';
import 'package:kt_dart/collection.dart';
import 'package:provider/provider.dart';

import '../bloc.dart';
import '../utils.dart';

@immutable
class CoursePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProxyProvider<ClientChannel, CourseBloc>(
        builder: (_, channel, __) => CourseBloc(channel),
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              title: Text('Courses'),
              bottom: TabBar(
                tabs: [
                  Tab(text: 'Current courses'),
                  Tab(text: 'All courses'),
                ],
              ),
            ),
            body: TabBarView(
              children: [CourseList(), CourseSeriesList()],
            ),
          ),
        ));
  }
}

class CourseSeriesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<KtList<CourseSeries>>(
      stream: Provider.of<CourseBloc>(context).getAllCourseSeries(),
      builder: (context, snapshot) {
        if (snapshot.hasError)
          return Center(child: Text(snapshot.error.toString()));
        if (!snapshot.hasData) return Placeholder();

        return ListView(
          children: snapshot.data
              .map((c) => ExpansionTile(
                    title: Text(c.title),
                    children: <Widget>[
                      ListTile(
                        title: Text(
                            '''${c.ects} ECTS · ${c.hoursPerWeek} h/week'''),
                        subtitle: Text(c.types
                            .map((t) => courseTypeToString(t))
                            .joinToString(separator: ' · ')),
                        leading: Icon(Icons.info_outline),
                      ),
                      ListTile(
                        title: Text(getLanguage(c.language)),
                        leading: Icon(Icons.language),
                      ),
                    ],
                  ))
              .asList(),
        );
      },
    );
  }
}

class CourseList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<KtList<Course>>(
      stream: Provider.of<CourseBloc>(context).getCourses(),
      builder: (context, snapshot) {
        if (snapshot.hasError)
          return Center(child: Text(snapshot.error.toString()));
        if (!snapshot.hasData) return Placeholder();

        return ListView(
          children: snapshot.data
              .map((c) => ListTile(
                    title: StreamBuilder<CourseSeries>(
                      stream: Provider.of<CourseBloc>(context)
                          .getCourseSeries(c.courseSeriesId),
                      builder: (context, snapshot) {
                        if (snapshot.hasError)
                          return Text(snapshot.error.toString());
                        if (!snapshot.hasData) return Text('Loading...');

                        return Text(snapshot.data.title);
                      },
                    ),
                    subtitle: Text(c.lecturer),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CourseDetailPage(c),
                      ));
                    },
                  ))
              .asList(),
        );
      },
    );
  }
}