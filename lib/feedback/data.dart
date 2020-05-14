import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'package:hpi_flutter/hpi_cloud_apis/hpi/cloud/feedback/v1test/feedback.pb.dart'
    as proto;

@immutable
class Feedback {
  const Feedback({
    @required this.id,
    @required this.message,
    this.screenUri,
    this.user,
    this.screenshot,
    this.log,
  })  : assert(id != null),
        assert(message != null);

  Feedback.fromProto(proto.Feedback feedback)
      : this(
          id: feedback.id,
          message: feedback.message,
          screenUri: Uri.tryParse(feedback.screenUri),
          user: feedback.user,
          screenshot: Uint8List.fromList(feedback.screenshot),
          log: feedback.log,
        );

  final String id;
  final String message;
  final Uri screenUri;
  final String user;
  final Uint8List screenshot;
  final String log;

  static Future<Feedback> create(
    String message, {
    Uri screenUri,
    bool includeContact,
    bool includeScreenshot,
    Uint8List screenshot,
    bool includeLogs,
  }) async {
    assert(message != null);

    // TODO(ctiedt): implement when login is available, https://github.com/HPI-de/hpi_flutter/issues/114
    String user;
    String log;
    if (includeLogs) {
      try {
        log = await MethodChannel('feedback').invokeMethod('getLog');
      } on PlatformException catch (e) {
        log = 'ERROR: PlatformException while reading log:\n$e';
      }
    }

    return Feedback(
      id: '',
      message: message,
      screenUri: screenUri,
      user: user,
      screenshot: screenshot,
      log: log,
    );
  }

  proto.Feedback toProto() {
    final f = proto.Feedback()
      ..id = id
      ..message = message;
    if (screenUri != null) {
      f.screenUri = screenUri.toString();
    }
    if (user != null) {
      f.user = user;
    }
    if (screenshot != null) {
      f.screenshot = screenshot;
    }
    if (log != null) {
      f.log = log;
    }
    return f;
  }
}
