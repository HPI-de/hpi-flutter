import 'package:kt_dart/collection.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'course.dart';

const String COURSE_URL = 'https://open.hpi.de/api/v2/courses';
const String HEADER_ACCEPT = 'Accept';
const String OPEN_HPI_ACCEPT = 'application/vnd.api+json; xikolo-version=3.7';

@immutable
class OpenHpiBloc {
  Future<String> fetchData(String link, {Map<String, String> headers}) async {
    final response = await http.get(Uri.parse(link), headers: headers);
    if (response.statusCode == 200) {
      // If server returns an OK response, return the response body.
      return Encoding.getByName('UTF-8').decode(response.bodyBytes);
    } else {
      // If that response was not OK, throw an error.
      throw Exception(
          'Failed to load data, status code: ${response.statusCode} ($response)');
    }
  }

  Stream<KtList<OpenHpiCourse>> getCourses() {
    return Stream.fromFuture(
      fetchData(
        COURSE_URL,
        headers: {HEADER_ACCEPT: OPEN_HPI_ACCEPT},
      ).then((jsonString) =>
          KtList.from(jsonDecode(jsonString)['data'] as Iterable).map(
            (course) => OpenHpiCourse.fromJson(
              course['attributes'] as Map<String, dynamic>,
            ),
          )),
    );
  }

  Stream<KtList<OpenHpiCourse>> getAnnouncedCourses() {
    return getCourses().map(
      (list) => list
          .filter((course) => course.status == 'announced')
          .sortedBy((c) => c.startAt),
    );
  }
}
