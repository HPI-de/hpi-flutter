import 'package:flutter/foundation.dart';
import 'package:grpc/grpc.dart';
import 'package:hpi_flutter/hpi_cloud_apis/hpi/cloud/course/v1test/course_service.pbgrpc.dart';
import 'package:kt_dart/collection.dart';

import 'data/course.dart';

@immutable
class CourseBloc {
  final CourseServiceClient _client;

  CourseBloc(ClientChannel channel)
      : assert(channel != null),
        _client = CourseServiceClient(channel);

  Stream<KtList<CourseSeries>> getAllCourseSeries() {
    return Stream.fromFuture(
            _client.listCourseSeries(ListCourseSeriesRequest()))
        .map((r) =>
            KtList.from(r.courseSeries).map((c) => CourseSeries.fromProto(c)));
  }

  Stream<CourseSeries> getCourseSeries(String id) {
    assert(id != null);
    return Stream.fromFuture(
            _client.getCourseSeries(GetCourseSeriesRequest()..id = id))
        .map((c) => CourseSeries.fromProto(c));
  }

  Stream<KtList<Course>> getCourses() {
    return Stream.fromFuture(_client.listCourses(ListCoursesRequest()))
        .map((r) => KtList.from(r.courses).map((c) => Course.fromProto(c)));
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
