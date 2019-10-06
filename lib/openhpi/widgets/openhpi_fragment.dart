import 'package:flutter/material.dart';
import 'package:hpi_flutter/app/widgets/dashboard_page.dart';
import 'package:hpi_flutter/app/widgets/utils.dart';
import 'package:hpi_flutter/core/localizations.dart';
import 'package:meta/meta.dart';
import 'package:flutter/widgets.dart';
import 'package:kt_dart/collection.dart';
import 'package:provider/provider.dart';

import '../data/bloc.dart';
import '../data/course.dart';
import 'course_preview.dart';

@immutable
class OpenHpiFragment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DashboardFragment(
      title: Text(HpiL11n.get(context, 'openHpi/fragment.title')),
      child: Provider<OpenHpiBloc>(
        builder: (_) => OpenHpiBloc(),
        child: SizedBox(
          height: 150,
          child: Builder(
            builder: (context) => _buildCourseList(context),
          ),
        ),
      ),
    );
  }

  Widget _buildCourseList(BuildContext context) {
    return StreamBuilder<KtList<OpenHpiCourse>>(
      stream: Provider.of<OpenHpiBloc>(context).getAnnouncedCourses(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return buildLoadingError(snapshot);

        return ListView.separated(
          padding: EdgeInsets.all(8),
          scrollDirection: Axis.horizontal,
          itemCount: snapshot.data.size,
          itemBuilder: (context, index) =>
              OpenHpiCoursePreview(snapshot.data[index]),
          separatorBuilder: (context, index) => SizedBox(width: 8),
        );
      },
    );
  }
}
