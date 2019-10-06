import 'package:meta/meta.dart';
import 'package:repository/repository.dart';

import 'entity.dart';

class GrpcDownloader<Item extends Entity, ProtoItem> extends Repository<Item> {
  final Future<ProtoItem> Function(String id) download;
  final Future<List<ProtoItem>> Function() downloadAll;
  final Item Function(ProtoItem protoItem) toProto;

  GrpcDownloader({
    @required this.download,
    @required this.downloadAll,
    @required this.toProto,
  })  : assert(
            download != null || downloadAll != null,
            'The grpc should be able to download items. Either provide a '
            'download method or a downloadAll method or both.'),
        assert(toProto != null),
        super(isFinite: downloadAll != null, isMutable: false);

  @override
  Stream<Item> fetch(Id<Item> id) async* {
    yield toProto(await download(id.id));
  }

  @override
  Stream<Map<Id<Item>, Item>> fetchAll() async* {
    yield {
      for (var item in (await downloadAll()).map(toProto))
        Id<Item>(item.id): item,
    };
  }
}
