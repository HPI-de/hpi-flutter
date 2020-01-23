import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:grpc/grpc.dart';
import 'package:hpi_flutter/core/data/utils.dart';
import 'package:hpi_flutter/core/widgets/pagination.dart';
import 'package:hpi_flutter/hpi_cloud_apis/hpi/cloud/course/v1test/course_service.pbgrpc.dart';
import 'package:kt_dart/collection.dart';

import 'course.dart';

@immutable
class CourseBloc {
  CourseBloc(Uri serverUrl, Locale locale)
      : assert(serverUrl != null),
        assert(locale != null),
        _client = CourseServiceClient(
          ClientChannel(
            serverUrl.toString(),
            port: 50062,
            options: ChannelOptions(
              credentials: ChannelCredentials.insecure(),
            ),
          ),
          options: createCallOptions(locale),
        );

  final CourseServiceClient _client;

  Future<PaginationResponse<CourseSeries>> getAllCourseSeries({
    int pageSize,
    String pageToken,
  }) async {
    final request = ListCourseSeriesRequest()
      ..pageSize = pageSize ?? 0
      ..pageToken = pageToken ?? '';
    final response = await _client.listCourseSeries(request);

    return PaginationResponse(
      KtList.from(response.courseSeries).map((a) => CourseSeries.fromProto(a)),
      response.nextPageToken,
    );
  }

  Future<CourseSeries> getCourseSeries(String id) async {
    assert(id != null);

    final request = GetCourseSeriesRequest()..id = id;
    final response = await _client.getCourseSeries(request);

    return CourseSeries.fromProto(response);
  }

  Future<Semester> getSemester(String id) async {
    assert(id != null);

    final request = GetSemesterRequest()..id = id;
    final response = await _client.getSemester(request);

    return Semester.fromProto(response);
  }

  Future<PaginationResponse<Course>> getCourses({
    int pageSize,
    String pageToken,
  }) async {
    final request = ListCoursesRequest()
      ..pageSize = pageSize ?? 0
      ..pageToken = pageToken ?? '';
    final response = await _client.listCourses(request);

    return PaginationResponse(
      KtList.from(response.courses).map((a) => Course.fromProto(a)),
      response.nextPageToken,
    );
  }

  Future<Course> getCourse(String id) async {
    assert(id != null);

    final request = GetCourseRequest()..id = id;
    final response = await _client.getCourse(request);

    return Course.fromProto(response);
  }

  Future<CourseDetail> getCourseDetail(String courseId) async {
    assert(courseId != null);

    final request = GetCourseDetailRequest()..courseId = courseId;
    final response = await _client.getCourseDetail(request);

    return CourseDetail.fromProto(response);
  }
}
