import 'dart:async';
import 'dart:convert';

import 'package:dartx/dartx.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import 'data.dart';

const String courseUrl = 'https://open.hpi.de/api/v2/courses';
const String headerAccept = 'Accept';
const String headerAcceptValue = 'application/vnd.api+json; xikolo-version=3.7';

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

  Stream<List<OpenHpiCourse>> getCourses() async* {
    final jsonString = await fetchData(
      courseUrl,
      headers: {headerAccept: headerAcceptValue},
    );

    yield (jsonDecode(jsonString)['data'] as Iterable<dynamic>)
        .map((course) => OpenHpiCourse.fromJson(
              course['attributes'] as Map<String, dynamic>,
            ))
        .toList();
  }

  Stream<List<OpenHpiCourse>> getAnnouncedCourses() {
    return getCourses().map(
      (list) => list
          .where((course) => course.status == 'announced')
          .sortedBy((c) => c.startAt),
    );
  }
}
