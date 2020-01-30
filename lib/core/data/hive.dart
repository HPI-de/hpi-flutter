import 'dart:ui';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hpi_flutter/food/data/restaurant.dart';
import 'package:kt_dart/kt.dart';

import 'cache.dart';
import 'entity.dart';

bool _isHiveInitialized = false;

class ColorAdapter extends TypeAdapter<Color> {
  @override
  int get typeId => TypeId.typeColor;

  @override
  Color read(BinaryReader reader) => Color(reader.readInt());

  @override
  void write(BinaryWriter writer, Color color) => writer.writeInt(color.value);
}

class KtSetAdapter<Item> extends TypeAdapter<KtSet<Item>> {
  @override
  final int typeId = TypeId.typeKtSet;

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
  final int typeId = TypeId.typeKtList;

  @override
  KtList<Item> read(BinaryReader reader) {
    return KtList.from(reader.readList().cast<Item>());
  }

  @override
  void write(BinaryWriter writer, KtList obj) {
    writer.writeList(obj.toList().asList());
  }
}

abstract class TypeId {
  static const typeRelations = 1;
  static const typeColor = 2;
  static const typeKtSet = 3;
  static const typeKtList = 4;
  static const typeRestaurant = 5;
  static const typeMenuItem = 6;
  static const typeLabel = 7;
}

Future<void> initializeHive() async {
  if (_isHiveInitialized) return;
  _isHiveInitialized = true;

  await Hive.initFlutter();

  Hive
    // General:
    ..registerAdapter(RelationsAdapter())
    ..registerAdapter(ColorAdapter())
    ..registerAdapter(KtSetAdapter())
    ..registerAdapter(KtListAdapter())
    // App module:
    ..registerAdapter(MenuItemAdapter())
    ..registerAdapter(RestaurantAdapter())
    ..registerAdapter(LabelAdapter());
}
