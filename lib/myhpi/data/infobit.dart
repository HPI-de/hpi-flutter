import 'package:flutter/foundation.dart';
import 'package:kt_dart/collection.dart';
import 'package:hpi_flutter/hpi_cloud_apis/hpi/cloud/myhpi/v1test/info_bit.pb.dart'
    as proto;

@immutable
class InfoBit {
  final String id;
  final String title;
  final String description;
  final KtList<String> actionIds;

  InfoBit({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.actionIds,
  })  : assert(id != null),
        assert(title != null),
        assert(description != null),
        assert(actionIds != null);

  InfoBit.fromProto(proto.InfoBit infoBit)
      : this(
            id: infoBit.id,
            title: infoBit.title,
            description: infoBit.description,
            actionIds: KtList.from(infoBit.actionIds));

  proto.InfoBit toProto() {
    return proto.InfoBit()
      ..id = id
      ..title = title
      ..description = description
      ..actionIds.addAll(actionIds.iter);
  }
}

@immutable
abstract class Action {
  final String id;
  final String title;

  Action({
    @required this.id,
    @required this.title,
  })  : assert(id != null),
        assert(title != null);

  Action._fromProto(proto.Action action)
      : this(id: action.id, title: action.title);

  factory Action.fromProto(proto.Action action) {
    switch (action.whichType()) {
      case proto.Action_Type.text:
        return ActionText.fromProto(action);
      case proto.Action_Type.link:
        return ActionLink.fromProto(action);
      default:
        return null;
    }
  }

  proto.Action toProto() {
    var action = proto.Action()
      ..id = id
      ..title = title;
    _writeToProto(action);
    return action;
  }

  void _writeToProto(proto.Action action);
}

@immutable
class ActionText extends Action {
  final String content;

  ActionText({
    @required String id,
    @required String title,
    @required this.content,
  })  : assert(content != null),
        super(id: id, title: title);

  ActionText.fromProto(proto.Action action)
      : assert(action.text != null),
        content = action.text.content,
        super._fromProto(action);

  @override
  void _writeToProto(proto.Action action) {
    action.text.content = content;
  }
}

@immutable
class ActionLink extends Action {
  final String url;

  ActionLink({
    @required String id,
    @required String title,
    @required this.url,
  })  : assert(url != null),
        super(id: id, title: title);

  ActionLink.fromProto(proto.Action action)
      : assert(action.link != null),
        url = action.link.url,
        super._fromProto(action);

  @override
  void _writeToProto(proto.Action action) {
    action.link.url = url;
  }
}
