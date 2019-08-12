import 'package:flutter/material.dart';
import 'package:grpc/grpc.dart';
import '../data/course.dart';
import 'package:kt_dart/collection.dart';
import 'package:provider/provider.dart';

import '../bloc.dart';

class CoursePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProxyProvider<ClientChannel, CourseBloc>(
        builder: (_, channel, __) => CourseBloc(channel),
        child: DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              title: Text('Courses'),
              bottom: TabBar(
                tabs: [
                  Tab(text: 'My courses'),
                  Tab(text: '180'),
                  Tab(text: 'All courses'),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                CourseList(),
                Center(
                  child: Text('In progress!'),
                ),
                CourseSeriesList()
              ],
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
              .map((c) => ListTile(
                    title: Text(c.title),
                    subtitle: Text(c.language),
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
                    title: Text(c.courseSeriesId),
                    subtitle: Text(c.lecturer),
                  ))
              .asList(),
        );
      },
    );
  }
}
