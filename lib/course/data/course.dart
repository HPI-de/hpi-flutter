import 'package:fixnum/fixnum.dart';
import 'package:hpi_flutter/hpi_cloud_apis/hpi/cloud/course/v1test/course.pb.dart'
    as proto;
import 'package:kt_dart/collection.dart';
import 'package:meta/meta.dart';

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
    @required this.language,
    @required this.types,
  })  : assert(id != null),
        assert(title != null),
        assert(shortTitle != null),
        assert(abbreviation != null),
        assert(ects != null),
        assert(hoursPerWeek != null),
        assert(mandatory != null),
        assert(language != null),
        assert(types != null);

  CourseSeries.fromProto(proto.CourseSeries courseSeries)
      : this(
          id: courseSeries.id,
          title: courseSeries.title,
          shortTitle: courseSeries.shortTitle,
          abbreviation: courseSeries.abbreviation,
          ects: courseSeries.ects,
          hoursPerWeek: courseSeries.hoursPerWeek,
          mandatory: courseSeries.mandatory,
          language: courseSeries.language,
          types: KtSet.from(courseSeries.types)
              .map((t) => typeFromProto(t))
              .toSet(),
        );

  proto.CourseSeries toProto() {
    return proto.CourseSeries()
      ..id = id
      ..title = title
      ..shortTitle = shortTitle
      ..abbreviation = abbreviation
      ..ects = ects
      ..hoursPerWeek = hoursPerWeek
      ..mandatory = mandatory
      ..language = language
      ..types.addAll(types.map((t) => typeToProto(t)).iter);
  }

  static Type typeFromProto(proto.CourseSeries_Type type) {
    switch (type) {
      case proto.CourseSeries_Type.LECTURE:
        return Type.LECTURE;
      case proto.CourseSeries_Type.SEMINAR:
        return Type.SEMINAR;
      case proto.CourseSeries_Type.BLOCK_SEMINAR:
        return Type.BLOCK_SEMINAR;
      case proto.CourseSeries_Type.EXERCISE:
        return Type.EXERCISE;
      default:
        return null;
    }
  }

  static proto.CourseSeries_Type typeToProto(Type type) {
    switch (type) {
      case Type.LECTURE:
        return proto.CourseSeries_Type.LECTURE;
      case Type.SEMINAR:
        return proto.CourseSeries_Type.SEMINAR;
      case Type.BLOCK_SEMINAR:
        return proto.CourseSeries_Type.BLOCK_SEMINAR;
      case Type.EXERCISE:
        return proto.CourseSeries_Type.EXERCISE;
      default:
        return null;
    }
  }
}

enum Type {
  LECTURE,
  SEMINAR,
  BLOCK_SEMINAR,
  EXERCISE,
}

@immutable
class Semester {
  final String id;
  final Term term;
  final Int64 year;

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
          year: semester.year,
        );

  proto.Semester toProto() {
    return proto.Semester()
      ..id = id
      ..term = termToProto(term)
      ..year = year;
  }

  static Term termFromProto(proto.Semester_Term term) {
    switch (term) {
      case proto.Semester_Term.WINTER:
        return Term.WINTER;
      case proto.Semester_Term.SUMMER:
        return Term.SUMMER;
      default:
        return null;
    }
  }

  static proto.Semester_Term termToProto(Term term) {
    switch (term) {
      case Term.WINTER:
        return proto.Semester_Term.WINTER;
      case Term.SUMMER:
        return proto.Semester_Term.SUMMER;
      default:
        return null;
    }
  }
}

enum Term {
  WINTER,
  SUMMER,
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
    @required this.assistants,
    this.website,
  })  : assert(id != null),
        assert(courseSeriesId != null),
        assert(semesterId != null),
        assert(lecturer != null),
        assert(assistants != null);

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
      ..assistants.addAll(assistants.iter)
      ..website = website;
  }
}

@immutable
class CourseDetail {
  final String courseId;
  final String teletask;
  final KtMap<String, KtList<String>> programs;
  final String description;
  final String requirements;
  final String learning;
  final String examination;
  final String dates;
  final String literature;

  CourseDetail({
    @required this.courseId,
    this.teletask,
    @required this.programs,
    @required this.description,
    this.requirements,
    this.learning,
    this.examination,
    this.dates,
    this.literature,
  })  : assert(courseId != null),
        assert(programs != null),
        assert(description != null);

  CourseDetail.fromProto(proto.CourseDetail courseDetail)
      : this(
          courseId: courseDetail.courseId,
          teletask: courseDetail.teletask,
          programs: KtMap.from(courseDetail.programs
              .map((k, v) => MapEntry(k, KtList.from(v.programs)))),
          description: courseDetail.description,
          requirements: courseDetail.requirements,
          learning: courseDetail.learning,
          examination: courseDetail.examination,
          dates: courseDetail.dates,
          literature: courseDetail.literature,
        );

  proto.CourseDetail toProto() {
    return proto.CourseDetail()
      ..courseId = courseId
      ..teletask = teletask
      ..programs.addAll(programs
          .mapValues((e) =>
              proto.CourseDetail_ProgramList()..programs.addAll(e.value.iter))
          .asMap())
      ..description = description
      ..requirements = requirements
      ..learning = learning
      ..examination = examination
      ..dates = dates
      ..literature = literature;
  }
}
