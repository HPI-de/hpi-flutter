import 'package:flutter/foundation.dart';
import 'package:grpc/grpc.dart';
import 'package:hpi_flutter/app/app.dart';
import 'package:hpi_flutter/core/data/utils.dart';
import 'package:hpi_flutter/core/widgets/pagination.dart';
import 'package:hpi_flutter/hpi_cloud_apis/hpi/cloud/course/v1test/course_service.pbgrpc.dart';
import 'package:kt_dart/collection.dart';

import 'course.dart';

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
              KtList.from(r.courseSeries).map((a) => CourseSeries.fromProto(a)),
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
              KtList.from(r.courses).map((a) => Course.fromProto(a)),
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
