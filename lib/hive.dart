import 'package:hive/hive.dart';
import 'package:kt_dart/collection.dart';
import 'package:path_provider/path_provider.dart';

import 'food/data/restaurant.dart';

Future<void> initializeHive() async {
  Hive
    ..registerAdapter(KtSetAdapter<Label>(), 40)
    ..registerAdapter(KtSetAdapter<String>(), 41)
    ..registerAdapter(MenuItemAdapter(), 50)
    ..registerAdapter(RestaurantAdapter(), 51)
    ..registerAdapter(LabelAdapter(), 52)
    ..init((await getApplicationDocumentsDirectory()).path);
}

class KtSetAdapter<Item> extends TypeAdapter<KtSet<Item>> {
  @override
  KtSet<Item> read(BinaryReader reader) {
    return KtSet.from(reader.readList().cast<Item>());
  }

  @override
  void write(BinaryWriter writer, KtSet<Item> obj) {
    writer.writeList(obj.toList().asList());
  }
}

class KtListAdapter<Item> extends TypeAdapter<KtList<Item>> {
  @override
  KtList<Item> read(BinaryReader reader) {
    return KtList.from(reader.readList().cast<Item>());
  }

  @override
  void write(BinaryWriter writer, KtList obj) {
    writer.writeList(obj.toList().asList());
  }
}
