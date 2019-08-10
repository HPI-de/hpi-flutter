import 'package:kt_dart/collection.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'course.dart';

const String COURSE_URL = 'https://open.hpi.de/api/v2/courses';

@immutable
class OpenHpiCourseBloc {
  Future<String> fetchData(String link) async {
    final response = await http.get(Uri.parse(link));
    if (response.statusCode == 200) {
      // If server returns an OK response, return the response body.
      return response.body;
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load data');
    }
  }

  Stream<KtList<OpenHpiCourse>> getOpenHpiCourses() {
    return Stream.fromFuture(fetchData(COURSE_URL).then((jsonString) =>
        KtList.from(jsonDecode(jsonString)['data'] as Iterable).map((course) =>
            OpenHpiCourse.fromJson(
                course['attributes'] as Map<String, dynamic>))));
  }

  Stream<KtList<OpenHpiCourse>> getAnnouncedOpenHpiCourses() {
    return getOpenHpiCourses()
        .map((list) => list.filter((course) => course.status == 'announced'));
  }
}
