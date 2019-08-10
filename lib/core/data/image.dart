import 'package:hpi_flutter/hpi_cloud_apis/hpi/cloud/common/v1test/image.pb.dart'
    as proto;
import 'package:meta/meta.dart';

@immutable
class Image {
  final String source;
  final String alt;

  const Image({@required this.source, this.alt}) : assert(source != null);

  Image.fromProto(proto.Image image)
      : this(
          source: image.source,
          alt: image.alt,
        );
  proto.Image toProto() {
    return proto.Image()
      ..source = source
      ..alt = alt;
  }
}
