import 'package:hpi_flutter/hpi_cloud_apis/google/protobuf/wrappers.pb.dart'
    as proto;
import 'package:hpi_flutter/hpi_cloud_apis/google/type/date.pb.dart' as proto;
import 'package:hpi_flutter/hpi_cloud_apis/hpi/cloud/course/v1test/course.pb.dart'
    as proto;
import 'package:kt_dart/collection.dart';
import 'package:meta/meta.dart';
import 'package:immutable_proto/immutable_proto.dart';

part 'course.g.dart';

@ImmutableProto(proto.UInt32Value)
class MutableUInt32Value {
  @required
  int value;
}

@ImmutableProto(proto.Date)
class MutableDate {
  @required
  int year;

  @required
  int month;

  @required
  int day;
}

@ImmutableProto(proto.CourseSeries)
class MutableCourseSeries {
  @required
  String id;

  @required
  String title;

  @required
  String shortTitle;

  @required
  String abbreviation;

  @required
  int ects;

  @required
  int hoursPerWeek;

  @required
  proto.CourseSeries_Compulsory compulsory;

  @required
  String language;

  @required
  KtSet<Type> types;
}

@ImmutableProto(proto.Semester)
class MutableSemester {
  @required
  String id;

  @required
  proto.Semester_Term term;

  @required
  int year;
}

@ImmutableProto(proto.Course)
class MutableCourse {
  @required
  String id;

  @required
  String courseSeriesId;

  @required
  String semesterId;

  KtList<String> lecturers;

  KtList<String> assistants;

  String website;

  UInt32Value attendance;

  Date enrollmentDeadline;
}

@ImmutableProto(proto.CourseDetail)
class MutableCourseDetail {
  @required
  String courseId;

  String teletask;

  @required
  KtMap<String, KtList<String>> programs;

  @required
  String description;

  String requirements;

  String learning;

  String examination;

  String dates;

  String literature;
}
