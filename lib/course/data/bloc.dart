import 'package:flutter/foundation.dart';
import 'package:grpc/grpc.dart';
import 'package:hpi_flutter/hpi_cloud_apis/hpi/cloud/course/v1test/course_service.pbgrpc.dart';
import 'package:kt_dart/collection.dart';

import 'course.dart';

@immutable
class CourseBloc {
  CourseBloc(Uri serverUrl)
      : assert(serverUrl != null),
        _client = CourseServiceClient(
          ClientChannel(
            serverUrl.toString(),
            port: 50062,
            options: ChannelOptions(
              credentials: ChannelCredentials.insecure(),
            ),
          ),
        );

  final CourseServiceClient _client;

  Stream<KtList<CourseSeries>> getAllCourseSeries() {
    return Stream.fromFuture(
            _client.listCourseSeries(ListCourseSeriesRequest()))
        .map((r) => KtList.from(r.courseSeries)
            .map((c) => CourseSeries.fromProto(c))
            .sortedBy((cs) => cs.title));
  }

  Stream<CourseSeries> getCourseSeries(String id) {
    assert(id != null);
    return Stream.fromFuture(
            _client.getCourseSeries(GetCourseSeriesRequest()..id = id))
        .map((c) => CourseSeries.fromProto(c));
  }

  Stream<Semester> getSemester(String id) {
    assert(id != null);
    return Stream.fromFuture(_client.getSemester(GetSemesterRequest()..id = id))
        .map((c) => Semester.fromProto(c));
  }

  Stream<KtList<Course>> getCourses() {
    return Stream.fromFuture(_client.listCourses(ListCoursesRequest())).map(
        (r) => KtList.from(r.courses)
            .map((c) => Course.fromProto(c))
            .sortedBy((c) => c.id));
  }

  Stream<Course> getCourse(String id) {
    assert(id != null);
    return Stream.fromFuture(_client.getCourse(GetCourseRequest()..id = id))
        .map((c) => Course.fromProto(c));
  }

  Stream<CourseDetail> getCourseDetail(String courseId) {
    assert(courseId != null);
    return Stream.fromFuture(_client
            .getCourseDetail(GetCourseDetailRequest()..courseId = courseId))
        .map((c) => CourseDetail.fromProto(c));
  }
}
