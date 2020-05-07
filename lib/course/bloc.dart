import 'package:flutter/foundation.dart';
import 'package:grpc/grpc.dart';
import 'package:hpi_flutter/app/app.dart';
import 'package:hpi_flutter/core/core.dart';
import 'package:hpi_flutter/hpi_cloud_apis/hpi/cloud/course/v1test/course_service.pbgrpc.dart';

import 'data.dart';

@immutable
class CourseBloc {
  CourseBloc()
      : _client = CourseServiceClient(
          ClientChannel(
            services.get<Uri>().toString(),
            port: 50062,
            options: ChannelOptions(
              credentials: ChannelCredentials.insecure(),
            ),
          ),
          options: createCallOptions(),
        );

  final CourseServiceClient _client;

  Stream<PaginationResponse<CourseSeries>> getAllCourseSeries({
    int pageSize,
    String pageToken,
  }) {
    final request = ListCourseSeriesRequest()
      ..pageSize = pageSize ?? 0
      ..pageToken = pageToken ?? '';
    return Stream.fromFuture(_client.listCourseSeries(request))
        .map((r) => PaginationResponse(
              r.courseSeries.map((a) => CourseSeries.fromProto(a)).toList(),
              r.nextPageToken,
            ));
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

  Stream<PaginationResponse<Course>> getCourses({
    int pageSize,
    String pageToken,
  }) {
    final request = ListCoursesRequest()
      ..pageSize = pageSize ?? 0
      ..pageToken = pageToken ?? '';
    return Stream.fromFuture(_client.listCourses(request))
        .map((r) => PaginationResponse(
              r.courses.map((a) => Course.fromProto(a)).toList(),
              r.nextPageToken,
            ));
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
