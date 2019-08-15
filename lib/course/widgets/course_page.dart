import 'package:flutter/material.dart' hide Route;
import 'package:hpi_flutter/app/widgets/main_scaffold.dart';
import 'package:hpi_flutter/course/data/bloc.dart';
import 'package:hpi_flutter/route.dart';
import 'package:kt_dart/collection.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:provider/provider.dart';

import '../data/course.dart';
import '../utils.dart';

@immutable
class CoursePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProxyProvider<Uri, CourseBloc>(
      builder: (_, serverUrl, __) => CourseBloc(serverUrl),
      child: DefaultTabController(
        length: 2,
        child: MainScaffold(
          appBar: AppBar(
            title: Text("Courses"),
            bottom: TabBar(
              tabs: [
                Tab(text: "Current courses"),
                Tab(text: "All courses"),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              CourseList(),
              CourseSeriesList(),
            ],
          ),
        ),
      ),
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
              .map((c) => StreamBuilder<CourseSeries>(
                    stream: Provider.of<CourseBloc>(context)
                        .getCourseSeries(c.courseSeriesId),
                    builder: (context, snapshot) {
                      if (snapshot.hasError)
                        return Text(snapshot.error.toString());
                      if (!snapshot.hasData) return Text("Loading...");

                      return ListTile(
                        title: Text(snapshot.data.title),
                        subtitle: Text(c.lecturer),
                        onTap: () {
                          Navigator.of(context).pushNamed(
                              Route.coursesDetail.name,
                              arguments: c.id);
                        },
                      );
                    },
                  ))
              .asList(),
        );
      },
    );
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
                        leading: Icon(OMIcons.info),
                        title:
                            Text("${c.ects} ECTS · ${c.hoursPerWeek} h/week"),
                        subtitle: Text(c.types
                            .map((t) => courseTypeToString(t))
                            .joinToString(separator: " · ")),
                      ),
                      ListTile(
                        leading: Icon(OMIcons.language),
                        title: Text(getLanguage(c.language)),
                      ),
                    ],
                  ))
              .asList(),
        );
      },
    );
  }
}
