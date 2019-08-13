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
