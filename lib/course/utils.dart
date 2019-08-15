import 'data/course.dart';

String courseTypeToString(Type type) {
  switch (type) {
    case Type.LECTURE:
      return 'Lecture';
    case Type.SEMINAR:
      return 'Seminar';
    case Type.BLOCK_SEMINAR:
      return 'Block seminar';
    case Type.EXERCISE:
      return 'Exercise';
    default:
      return null;
  }
}

String getLanguage(String abbreviation) {
  switch (abbreviation) {
    case 'de':
      return 'German';
    case 'en':
      return 'English';
    default:
      return 'Unknown';
  }
}

String semesterToString(Semester semester) {
  String term;
  switch (semester.term) {
    case Term.WINTER:
      term = "Winter Term";
      break;
    case Term.SUMMER:
      term = "Summer Term";
      break;
  }
  return "$term ${semester.year}";
}
