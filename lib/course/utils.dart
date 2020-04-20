import 'package:dartx/dartx.dart';

import 'data.dart';

String buildProgramInfo(CourseDetail courseDetail) {
  return courseDetail.programs.entries.map((entry) {
    final modulesList = entry.value.programs.joinToString(
      separator: '\n',
      transform: (p) => '\t\t\t\t$p',
    );

    return '${entry.key}\v$modulesList';
  }).join('\n');
}
