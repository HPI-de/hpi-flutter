import 'package:flutter_cached/flutter_cached.dart';
import 'package:hive/hive.dart';
import 'package:kt_dart/collection.dart';
import 'package:meta/meta.dart';

import 'entity.dart';

class HiveCacheController<Item> extends CacheController<KtList<Item>> {
  final String name;

  HiveCacheController({
    @required this.name,
    @required Future<KtList<Item>> Function() fetcher,
  }) : super(
          saveToCache: (items) async {
            // When fetching items, they are returned sorted by their keys.
            // Integer keys can only go to 255, so we need to use Strings as
            // the only other alternative.
            // So we generate strings that are stored in the order of the
            // items.
            var box = await Hive.openBox(name);
            await box.clear();
            await box.addAll([
              for (var i = 0; i < items.size; i++) items[i],
            ]);
          },
          loadFromCache: () async {
            var box = await Hive.openBox(name);
            var items = KtList<Item>.from(box.toMap().values);
            if (items.isEmpty()) {
              throw Exception('Item not in cache.');
            } else {
              return items;
            }
          },
          fetcher: fetcher,
        );
}

Future<KtList<Item>> Function() grpcCollectionDownloader<Item, ProtoItem>({
  Future<List<ProtoItem>> Function() download,
  Item Function(ProtoItem proto) toProto,
}) {
  return () async {
    return KtList.from(await download()).map(toProto);
  };
}

Stream<Item> getItemWithId<Item extends Entity>(
  CacheController<KtList<Item>> controller,
  String id,
) {
  return controller.updates
      .map((update) => update.data)
      .map((labels) => labels.singleOrNull((label) => label.id == id));
}
