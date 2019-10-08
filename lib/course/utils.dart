import 'package:flutter/widgets.dart';
import 'package:hpi_flutter/core/localizations.dart';

import 'data/course.dart';

String courseTypeToString(BuildContext context, Type type) {
  assert(context != null);
  assert(type != null);

  return HpiL11n.get(context, 'course/course.type.${enumToKey(type)}');
}

String semesterToString(BuildContext context, Semester semester) {
  assert(context != null);
  assert(semester != null);

  return HpiL11n.get(
    context,
    'course/semester.${enumToKey(semester.term)}',
    args: [semester.year],
  );
}
