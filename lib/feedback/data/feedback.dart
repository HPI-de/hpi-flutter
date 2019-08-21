import 'package:flutter/foundation.dart';

import 'package:hpi_flutter/hpi_cloud_apis/hpi/cloud/feedback/v1test/feedback.pb.dart'
    as proto;

@immutable
class Feedback {
  final String id;
  final String message;
  final String screenUri;
  final String user;
  final List<int> screenshot;
  final String log;

  Feedback({
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
          screenUri: feedback.screenUri,
          user: feedback.user,
          screenshot: feedback.screenshot,
          log: feedback.log,
        );

  proto.Feedback toProto() {
    return proto.Feedback()
      ..id = id
      ..message = message
      ..screenUri = screenUri
      ..user = user
      ..screenshot = screenshot
      ..log = log;
  }
}
