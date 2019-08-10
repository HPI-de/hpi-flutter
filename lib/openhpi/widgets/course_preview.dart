import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/course.dart';

@immutable
class OpenHpiCoursePreview extends StatelessWidget {
  final OpenHpiCourse course;

  OpenHpiCoursePreview(this.course) : assert(course != null);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: <Widget>[
          Image.network(course.imageUrl.toString()),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(children: <Widget>[
              InkWell(
                onTap: () => launch(course.link.toString()),
                child: Text(
                  course.title,
                  style: Theme.of(context).textTheme.subhead,
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
