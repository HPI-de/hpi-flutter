import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:hpi_flutter/core/core.dart';
import 'package:hpi_flutter/hpi_cloud_apis/hpi/cloud/common/v1test/image.pb.dart'
    as proto;
import 'package:hpi_flutter/hpi_cloud_apis/hpi/cloud/myhpi/v1test/info_bit.pb.dart'
    as proto;
import 'package:immutable_proto/immutable_proto.dart';
import 'package:kt_dart/collection.dart';

part 'data.g.dart';

@ImmutableProto(proto.InfoBit)
class MutableInfoBit {
  @required
  String id;
  String parentId;
  @required
  String title;
  String subtitle;
  proto.Image cover;
  @required
  String description;
  String content;
  @required
  proto.InfoBit_ChildDisplay childDisplay;
  KtList<String> actionIds;
  KtList<String> tagIds;
}

@ImmutableProto(proto.InfoBitTag)
class MutableInfoBitTag {
  @required
  String id;
  @required
  String title;
}

@immutable
abstract class Action {
  final String id;
  final String title;
  final Uint8List icon;

  Action({
    @required this.id,
    @required this.title,
    this.icon,
  })  : assert(id != null),
        assert(title != null);

  Action._fromProto(proto.Action action)
      : this(
          id: action.id,
          title: action.title,
          icon: Uint8List.fromList(action.icon),
        );

  factory Action.fromProto(proto.Action action) {
    switch (action.whichType()) {
      case proto.Action_Type.text:
        return TextAction.fromProto(action);
      case proto.Action_Type.link:
        return LinkAction.fromProto(action);
      default:
        return null;
    }
  }

  proto.Action toProto() {
    final action = proto.Action()
      ..id = id
      ..title = title;
    if (icon != null) action.icon = icon.toList();
    _writeToProto(action);
    return action;
  }

  void _writeToProto(proto.Action action);
}

@immutable
class TextAction extends Action {
  final String content;

  TextAction({
    @required String id,
    @required String title,
    Uint8List icon,
    @required this.content,
  })  : assert(content != null),
        super(id: id, title: title, icon: icon);

  TextAction.fromProto(proto.Action action)
      : assert(action.text != null),
        content = action.text.content,
        super._fromProto(action);

  @override
  void _writeToProto(proto.Action action) {
    action.text.content = content;
  }
}

@immutable
class LinkAction extends Action {
  final String url;

  LinkAction({
    @required String id,
    @required String title,
    Uint8List icon,
    @required this.url,
  })  : assert(url != null),
        super(id: id, title: title, icon: icon);

  LinkAction.fromProto(proto.Action action)
      : assert(action.link != null),
        url = action.link.url,
        super._fromProto(action);

  @override
  void _writeToProto(proto.Action action) {
    action.link.url = url;
  }
}
