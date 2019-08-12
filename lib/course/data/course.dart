import 'package:fixnum/fixnum.dart';
import 'package:hpi_flutter/core/data/utils.dart';
import 'package:hpi_flutter/hpi_cloud_apis/hpi/cloud/course/v1test/course.pb.dart'
    as proto;
import 'package:kt_dart/collection.dart';
import 'package:meta/meta.dart';

enum Type {
  LECTURE,
  SEMINAR,
  BLOCK_SEMINAR,
  EXERCISE,
}

@immutable
class CourseSeries {
  final String id;
  final String title;
  final String shortTitle;
  final String abbreviation;
  final int ects;
  final int hoursPerWeek;
  final bool mandatory;
  final String language;
  final KtSet<Type> types;

  CourseSeries({
    @required this.id,
    @required this.title,
    @required this.shortTitle,
    @required this.abbreviation,
    @required this.ects,
    @required this.hoursPerWeek,
    @required this.mandatory,
    this.language,
    this.types,
  })  : assert(id != null),
        assert(title != null),
        assert(shortTitle != null),
        assert(abbreviation != null),
        assert(ects != null),
        assert(hoursPerWeek != null),
        assert(mandatory != null);

  CourseSeries.fromProto(proto.CourseSeries courseSeries)
      : this(
          id: courseSeries.id,
          title: courseSeries.title,
          shortTitle: courseSeries.shortTitle,
          abbreviation: courseSeries.abbreviation,
          ects: courseSeries.ects,
          hoursPerWeek: courseSeries.hoursPerWeek,
          mandatory: courseSeries.mandatory,
          //types: KtSet.from(courseSeries.types).map(.toSet(),
        );

  proto.CourseSeries toProto() {
    return proto.CourseSeries()
      ..id = id
      ..title = title
      ..shortTitle = shortTitle
      ..abbreviation = abbreviation
      ..ects = ects
      ..hoursPerWeek = hoursPerWeek
      ..mandatory = mandatory;
  }
}

enum Term {
  WINTER,
  SUMMER,
}

@immutable
class Semester {
  final String id;
  final Term term;
  final int year;

  static Term termFromProto(proto.Semester_Term term) {
    switch (term) {
      case proto.Semester_Term.WINTER:
        return Term.WINTER;
      case proto.Semester_Term.SUMMER:
        return Term.SUMMER;
    }
  }

  static proto.Semester_Term termToProto(Term term) {
    switch (term) {
      case Term.WINTER:
        return proto.Semester_Term.WINTER;
      case Term.SUMMER:
        return proto.Semester_Term.SUMMER;
    }
  }

  Semester({
    @required this.id,
    @required this.term,
    @required this.year,
  })  : assert(id != null),
        assert(term != null),
        assert(year != null);

  Semester.fromProto(proto.Semester semester)
      : this(
          id: semester.id,
          term: termFromProto(semester.term),
          year: semester.year.toInt(),
        );

  proto.Semester toProto() {
    return proto.Semester()
      ..id = id
      ..term = termToProto(term)
      ..year = year as Int64;
  }
}

@immutable
class Course {
  final String id;
  final String courseSeriesId;
  final String semesterId;
  final String lecturer;
  final KtSet<String> assistants;
  final String website;

  Course({
    @required this.id,
    @required this.courseSeriesId,
    @required this.semesterId,
    @required this.lecturer,
    this.assistants,
    this.website,
  })  : assert(id != null),
        assert(courseSeriesId != null),
        assert(semesterId != null),
        assert(lecturer != null);

  Course.fromProto(proto.Course course)
      : this(
          id: course.id,
          courseSeriesId: course.courseSeriesId,
          semesterId: course.semesterId,
          lecturer: course.lecturer,
          assistants: KtSet.from(course.assistants),
          website: course.website,
        );

  proto.Course toProto() {
    return proto.Course()
      ..id = id
      ..courseSeriesId = courseSeriesId
      ..semesterId = semesterId
      ..lecturer = lecturer
      //..assistants = assistants.toList().asList()
      ..website = website;
  }
}

@immutable
class CourseDetail {}
