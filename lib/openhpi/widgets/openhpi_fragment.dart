import 'package:flutter/material.dart';
import 'package:hpi_flutter/app/app.dart';
import 'package:hpi_flutter/app/widgets/dashboard_page.dart';
import 'package:hpi_flutter/app/widgets/utils.dart';
import 'package:hpi_flutter/core/localizations.dart';
import 'package:meta/meta.dart';
import 'package:flutter/widgets.dart';
import 'package:kt_dart/collection.dart';

import '../data/bloc.dart';
import '../data/course.dart';
import 'course_preview.dart';

@immutable
class OpenHpiFragment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DashboardFragment(
      title: Text(HpiL11n.get(context, 'openHpi/fragment.title')),
      child: SizedBox(
        height: 150,
        child: StreamBuilder<KtList<OpenHpiCourse>>(
          stream: services.get<OpenHpiBloc>().getAnnouncedCourses(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return buildLoadingError(snapshot);
            }

            return ListView.separated(
              padding: EdgeInsets.all(8),
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data.size,
              itemBuilder: (context, index) =>
                  OpenHpiCoursePreview(snapshot.data[index]),
              separatorBuilder: (context, index) => SizedBox(width: 8),
            );
          },
        ),
      ),
    );
  }
}
