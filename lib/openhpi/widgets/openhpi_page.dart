import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:flutter/widgets.dart';
import 'package:kt_dart/collection.dart';
import 'package:provider/provider.dart';

import '../data/bloc.dart';
import '../data/course.dart';
import 'course_preview.dart';

@immutable
class OpenHpiPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<OpenHpiCourseBloc>(
      builder: (_) => OpenHpiCourseBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("openHPI Courses"),
        ),
        body: OpenHpiCourseList(),
      ),
    );
  }
}

class OpenHpiCourseList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<KtList<OpenHpiCourse>>(
      stream:
          Provider.of<OpenHpiCourseBloc>(context).getAnnouncedOpenHpiCourses(),
      builder: (context, snapshot) {
        if (snapshot.hasError)
          return Center(
            child: Text(snapshot.error),
          );
        if (!snapshot.hasData)
          return Center(
            child: CircularProgressIndicator(),
          );
        return ListView(
          children: snapshot.data
              .map((course) => OpenHpiCoursePreview(course))
              .asList(),
        );
      },
    );
  }
}
