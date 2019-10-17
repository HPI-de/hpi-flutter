import 'package:hpi_flutter/hpi_cloud_apis/google/protobuf/wrappers.pb.dart'
    as proto;
import 'package:hpi_flutter/hpi_cloud_apis/google/type/date.pb.dart' as proto;
import 'package:hpi_flutter/hpi_cloud_apis/hpi/cloud/course/v1test/course.pb.dart'
    as proto;
import 'package:kt_dart/collection.dart';
import 'package:meta/meta.dart';
import 'package:immutable_proto/immutable_proto.dart';

@immutable
class UInt32Value {
  final int value;

  UInt32Value({this.value});

  UInt32Value.fromProto(proto.UInt32Value uInt32Value)
      : this(value: uInt32Value.hasValue() ? uInt32Value.value : null);
  proto.UInt32Value toProto() {
    final uInt32Value = proto.UInt32Value();
    if (value != null) uInt32Value.value = value;
    return uInt32Value;
  }

  bool operator ==(Object other) {
    return other is UInt32Value && value == other.value;
  }

  int get hashCode => hashList([
        value,
      ]);
  UInt32Value copy({
    int value,
  }) =>
      UInt32Value(
        value: value ?? this.value,
      );

  String toString() {
    return 'UInt32Value(value: $value)';
  }
}

@immutable
class Date {
  final int year;
  final int month;
  final int day;

  Date({
    @required this.year,
    @required this.month,
    @required this.day,
  });

  Date.fromProto(proto.Date date)
      : this(
          year: date.hasYear() ? date.year : null,
          month: date.hasMonth() ? date.month : null,
          day: date.hasDay() ? date.day : null,
        );
  proto.Date toProto() {
    final date = proto.Date();
    if (year != null) date.year = year;
    if (month != null) date.month = month;
    if (day != null) date.day = day;
    return date;
  }

  bool operator ==(Object other) {
    return other is Date &&
        year == other.year &&
        month == other.month &&
        day == other.day;
  }

  int get hashCode => hashList([
        year,
        month,
        day,
      ]);
  Date copy({
    int year,
    int month,
    int day,
  }) =>
      Date(
        year: year ?? this.year,
        month: month ?? this.month,
        day: day ?? this.day,
      );

  String toString() {
    return 'Date(year: $year, month: $month, day: $day)';
  }
}

enum CourseSeriesCompulsory { compulsory, bridge, nonCompulsory }

enum CourseSeriesType { seminar, blockSeminar, exercise, project, lecture }

@immutable
class CourseSeries {
  final String id;
  final String title;
  final String shortTitle;
  final String abbreviation;
  final int ects;
  final int hoursPerWeek;
  @required
  final CourseSeriesCompulsory compulsory;
  final String language;
  @required
  final KtList<CourseSeriesType> types;

  CourseSeries({
    this.id,
    this.title,
    this.shortTitle,
    this.abbreviation,
    this.ects,
    this.hoursPerWeek,
    @required this.compulsory,
    this.language,
    @required this.types,
  })  : assert(compulsory != null),
        assert(types != null);

  CourseSeries.fromProto(proto.CourseSeries courseSeries)
      : this(
          id: courseSeries.hasId() ? courseSeries.id : null,
          title: courseSeries.hasTitle() ? courseSeries.title : null,
          shortTitle:
              courseSeries.hasShortTitle() ? courseSeries.shortTitle : null,
          abbreviation:
              courseSeries.hasAbbreviation() ? courseSeries.abbreviation : null,
          ects: courseSeries.hasEcts() ? courseSeries.ects : null,
          hoursPerWeek:
              courseSeries.hasHoursPerWeek() ? courseSeries.hoursPerWeek : null,
          compulsory: courseSeriesCompulsoryFromProto(courseSeries.compulsory),
          language: courseSeries.hasLanguage() ? courseSeries.language : null,
          types: KtList.from(courseSeries.types)
              .map((t) => courseSeriesTypeFromProto(t)),
        );
  proto.CourseSeries toProto() {
    final courseSeries = proto.CourseSeries();
    if (id != null) courseSeries.id = id;
    if (title != null) courseSeries.title = title;
    if (shortTitle != null) courseSeries.shortTitle = shortTitle;
    if (abbreviation != null) courseSeries.abbreviation = abbreviation;
    if (ects != null) courseSeries.ects = ects;
    if (hoursPerWeek != null) courseSeries.hoursPerWeek = hoursPerWeek;
    courseSeries.compulsory = courseSeriesCompulsoryToProto(compulsory);
    if (language != null) courseSeries.language = language;
    courseSeries.types
        .addAll(types.map((t) => courseSeriesTypeToProto(t)).iter);
    return courseSeries;
  }

  bool operator ==(Object other) {
    return other is CourseSeries &&
        id == other.id &&
        title == other.title &&
        shortTitle == other.shortTitle &&
        abbreviation == other.abbreviation &&
        ects == other.ects &&
        hoursPerWeek == other.hoursPerWeek &&
        compulsory == other.compulsory &&
        language == other.language &&
        types == other.types;
  }

  int get hashCode => hashList([
        id,
        title,
        shortTitle,
        abbreviation,
        ects,
        hoursPerWeek,
        compulsory,
        language,
        types,
      ]);
  CourseSeries copy({
    String id,
    String title,
    String shortTitle,
    String abbreviation,
    int ects,
    int hoursPerWeek,
    CourseSeriesCompulsory compulsory,
    String language,
    KtList<CourseSeriesType> types,
  }) =>
      CourseSeries(
        id: id ?? this.id,
        title: title ?? this.title,
        shortTitle: shortTitle ?? this.shortTitle,
        abbreviation: abbreviation ?? this.abbreviation,
        ects: ects ?? this.ects,
        hoursPerWeek: hoursPerWeek ?? this.hoursPerWeek,
        compulsory: compulsory ?? this.compulsory,
        language: language ?? this.language,
        types: types ?? this.types,
      );

  String toString() {
    return 'CourseSeries(id: $id, title: $title, shortTitle: $shortTitle, abbreviation: $abbreviation, ects: $ects, hoursPerWeek: $hoursPerWeek, compulsory: $compulsory, language: $language, types: $types)';
  }

  static CourseSeriesCompulsory courseSeriesCompulsoryFromProto(
      proto.CourseSeries_Compulsory courseSeriesCompulsory) {
    switch (courseSeriesCompulsory) {
      case proto.CourseSeries_Compulsory.COMPULSORY:
        return CourseSeriesCompulsory.compulsory;
      case proto.CourseSeries_Compulsory.BRIDGE:
        return CourseSeriesCompulsory.bridge;
      case proto.CourseSeries_Compulsory.NON_COMPULSORY:
      default:
        return CourseSeriesCompulsory.nonCompulsory;
    }
  }

  static proto.CourseSeries_Compulsory courseSeriesCompulsoryToProto(
      CourseSeriesCompulsory courseSeriesCompulsory) {
    switch (courseSeriesCompulsory) {
      case CourseSeriesCompulsory.compulsory:
        return proto.CourseSeries_Compulsory.COMPULSORY;
      case CourseSeriesCompulsory.bridge:
        return proto.CourseSeries_Compulsory.BRIDGE;
      case CourseSeriesCompulsory.nonCompulsory:
      default:
        return proto.CourseSeries_Compulsory.NON_COMPULSORY;
    }
  }

  static CourseSeriesType courseSeriesTypeFromProto(
      proto.CourseSeries_Type courseSeriesType) {
    switch (courseSeriesType) {
      case proto.CourseSeries_Type.SEMINAR:
        return CourseSeriesType.seminar;
      case proto.CourseSeries_Type.BLOCK_SEMINAR:
        return CourseSeriesType.blockSeminar;
      case proto.CourseSeries_Type.EXERCISE:
        return CourseSeriesType.exercise;
      case proto.CourseSeries_Type.PROJECT:
        return CourseSeriesType.project;
      case proto.CourseSeries_Type.LECTURE:
      default:
        return CourseSeriesType.lecture;
    }
  }

  static proto.CourseSeries_Type courseSeriesTypeToProto(
      CourseSeriesType courseSeriesType) {
    switch (courseSeriesType) {
      case CourseSeriesType.seminar:
        return proto.CourseSeries_Type.SEMINAR;
      case CourseSeriesType.blockSeminar:
        return proto.CourseSeries_Type.BLOCK_SEMINAR;
      case CourseSeriesType.exercise:
        return proto.CourseSeries_Type.EXERCISE;
      case CourseSeriesType.project:
        return proto.CourseSeries_Type.PROJECT;
      case CourseSeriesType.lecture:
      default:
        return proto.CourseSeries_Type.LECTURE;
    }
  }
}

@immutable
class Semester {
  final String id;
  @required
  final SemesterTerm term;
  final int year;

  Semester({
    this.id,
    @required this.term,
    this.year,
  }) : assert(term != null);

  Semester.fromProto(proto.Semester semester)
      : this(
          id: semester.hasId() ? semester.id : null,
          term: semesterTermFromProto(semester.term),
          year: semester.hasYear() ? semester.year : null,
        );
  proto.Semester toProto() {
    final semester = proto.Semester();
    if (id != null) semester.id = id;
    semester.term = semesterTermToProto(term);
    if (year != null) semester.year = year;
    return semester;
  }

  bool operator ==(Object other) {
    return other is Semester &&
        id == other.id &&
        term == other.term &&
        year == other.year;
  }

  int get hashCode => hashList([
        id,
        term,
        year,
      ]);
  Semester copy({
    String id,
    SemesterTerm term,
    int year,
  }) =>
      Semester(
        id: id ?? this.id,
        term: term ?? this.term,
        year: year ?? this.year,
      );

  String toString() {
    return 'Semester(id: $id, term: $term, year: $year)';
  }

  static SemesterTerm semesterTermFromProto(proto.Semester_Term semesterTerm) {
    switch (semesterTerm) {
      case proto.Semester_Term.SUMMER:
        return SemesterTerm.summer;
      case proto.Semester_Term.WINTER:
      default:
        return SemesterTerm.winter;
    }
  }

  static proto.Semester_Term semesterTermToProto(SemesterTerm semesterTerm) {
    switch (semesterTerm) {
      case SemesterTerm.summer:
        return proto.Semester_Term.SUMMER;
      case SemesterTerm.winter:
      default:
        return proto.Semester_Term.WINTER;
    }
  }
}

enum SemesterTerm { winter, summer }

@immutable
class Course {
  final String id;
  final String courseSeriesId;
  final String semesterId;
  @required
  final KtList<String> lecturers;
  @required
  final KtList<String> assistants;
  final String website;
  final UInt32Value attendance;
  final Date enrollmentDeadline;

  Course({
    this.id,
    this.courseSeriesId,
    this.semesterId,
    @required this.lecturers,
    @required this.assistants,
    this.website,
    this.attendance,
    this.enrollmentDeadline,
  })  : assert(lecturers != null),
        assert(assistants != null);

  Course.fromProto(proto.Course course)
      : this(
          id: course.hasId() ? course.id : null,
          courseSeriesId:
              course.hasCourseSeriesId() ? course.courseSeriesId : null,
          semesterId: course.hasSemesterId() ? course.semesterId : null,
          lecturers: KtList.from(course.lecturers),
          assistants: KtList.from(course.assistants),
          website: course.hasWebsite() ? course.website : null,
          attendance: course.hasAttendance()
              ? UInt32Value.fromProto(course.attendance)
              : null,
          enrollmentDeadline: course.hasEnrollmentDeadline()
              ? Date.fromProto(course.enrollmentDeadline)
              : null,
        );
  proto.Course toProto() {
    final course = proto.Course();
    if (id != null) course.id = id;
    if (courseSeriesId != null) course.courseSeriesId = courseSeriesId;
    if (semesterId != null) course.semesterId = semesterId;
    course.lecturers.addAll(lecturers.iter);
    course.assistants.addAll(assistants.iter);
    if (website != null) course.website = website;
    if (attendance != null) course.attendance = attendance.toProto();
    if (enrollmentDeadline != null) {
      course.enrollmentDeadline = enrollmentDeadline.toProto();
    }
    return course;
  }

  bool operator ==(Object other) {
    return other is Course &&
        id == other.id &&
        courseSeriesId == other.courseSeriesId &&
        semesterId == other.semesterId &&
        lecturers == other.lecturers &&
        assistants == other.assistants &&
        website == other.website &&
        attendance == other.attendance &&
        enrollmentDeadline == other.enrollmentDeadline;
  }

  int get hashCode => hashList([
        id,
        courseSeriesId,
        semesterId,
        lecturers,
        assistants,
        website,
        attendance,
        enrollmentDeadline,
      ]);
  Course copy({
    String id,
    String courseSeriesId,
    String semesterId,
    KtList<String> lecturers,
    KtList<String> assistants,
    String website,
    UInt32Value attendance,
    Date enrollmentDeadline,
  }) =>
      Course(
        id: id ?? this.id,
        courseSeriesId: courseSeriesId ?? this.courseSeriesId,
        semesterId: semesterId ?? this.semesterId,
        lecturers: lecturers ?? this.lecturers,
        assistants: assistants ?? this.assistants,
        website: website ?? this.website,
        attendance: attendance ?? this.attendance,
        enrollmentDeadline: enrollmentDeadline ?? this.enrollmentDeadline,
      );

  String toString() {
    return 'Course(id: $id, courseSeriesId: $courseSeriesId, semesterId: $semesterId, lecturers: $lecturers, assistants: $assistants, website: $website, attendance: $attendance, enrollmentDeadline: $enrollmentDeadline)';
  }
}

@immutable
class CourseDetail {
  final String courseId;
  final String teletask;
  final Map<String, CourseDetailProgramList> programs;
  final String description;
  final String requirements;
  final String learning;
  final String examination;
  final String dates;
  final String literature;

  CourseDetail({
    this.courseId,
    this.teletask,
    this.programs,
    this.description,
    this.requirements,
    this.learning,
    this.examination,
    this.dates,
    this.literature,
  });

  CourseDetail.fromProto(proto.CourseDetail courseDetail)
      : this(
          courseId: courseDetail.hasCourseId() ? courseDetail.courseId : null,
          teletask: courseDetail.hasTeletask() ? courseDetail.teletask : null,
          programs: {
            for (var entry in courseDetail.programs.entries)
              entry.key: CourseDetailProgramList.fromProto(entry.value),
          },
          description:
              courseDetail.hasDescription() ? courseDetail.description : null,
          requirements:
              courseDetail.hasRequirements() ? courseDetail.requirements : null,
          learning: courseDetail.hasLearning() ? courseDetail.learning : null,
          examination:
              courseDetail.hasExamination() ? courseDetail.examination : null,
          dates: courseDetail.hasDates() ? courseDetail.dates : null,
          literature:
              courseDetail.hasLiterature() ? courseDetail.literature : null,
        );
  proto.CourseDetail toProto() {
    final courseDetail = proto.CourseDetail();
    if (courseId != null) courseDetail.courseId = courseId;
    if (teletask != null) courseDetail.teletask = teletask;
    if (programs != null) {
      courseDetail.programs
        ..clear()
        ..addAll({
          for (var entry in programs.entries) entry.key: entry.value.toProto()
        });
    }
    if (description != null) courseDetail.description = description;
    if (requirements != null) courseDetail.requirements = requirements;
    if (learning != null) courseDetail.learning = learning;
    if (examination != null) courseDetail.examination = examination;
    if (dates != null) courseDetail.dates = dates;
    if (literature != null) courseDetail.literature = literature;
    return courseDetail;
  }

  bool operator ==(Object other) {
    return other is CourseDetail &&
        courseId == other.courseId &&
        teletask == other.teletask &&
        programs == other.programs &&
        description == other.description &&
        requirements == other.requirements &&
        learning == other.learning &&
        examination == other.examination &&
        dates == other.dates &&
        literature == other.literature;
  }

  int get hashCode => hashList([
        courseId,
        teletask,
        programs,
        description,
        requirements,
        learning,
        examination,
        dates,
        literature,
      ]);
  CourseDetail copy({
    String courseId,
    String teletask,
    Map programs,
    String description,
    String requirements,
    String learning,
    String examination,
    String dates,
    String literature,
  }) =>
      CourseDetail(
        courseId: courseId ?? this.courseId,
        teletask: teletask ?? this.teletask,
        programs: programs ?? this.programs,
        description: description ?? this.description,
        requirements: requirements ?? this.requirements,
        learning: learning ?? this.learning,
        examination: examination ?? this.examination,
        dates: dates ?? this.dates,
        literature: literature ?? this.literature,
      );

  String toString() {
    return 'CourseDetail(courseId: $courseId, teletask: $teletask, programs: $programs, description: $description, requirements: $requirements, learning: $learning, examination: $examination, dates: $dates, literature: $literature)';
  }
}

@immutable
class CourseDetailProgramList {
  @required
  final KtList<String> programs;

  CourseDetailProgramList({
    @required this.programs,
  }) : assert(programs != null);

  CourseDetailProgramList.fromProto(
      proto.CourseDetail_ProgramList courseDetailProgramList)
      : this(
          programs: KtList.from(courseDetailProgramList.programs),
        );
  proto.CourseDetail_ProgramList toProto() {
    final courseDetailProgramList = proto.CourseDetail_ProgramList();
    courseDetailProgramList.programs.addAll(programs.iter);
    return courseDetailProgramList;
  }

  bool operator ==(Object other) {
    return other is CourseDetailProgramList && programs == other.programs;
  }

  int get hashCode => hashList([
        programs,
      ]);
  CourseDetailProgramList copy({
    KtList<String> programs,
  }) =>
      CourseDetailProgramList(
        programs: programs ?? this.programs,
      );

  String toString() {
    return 'CourseDetailProgramList(programs: $programs)';
  }
}
