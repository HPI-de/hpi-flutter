import 'dart:ui';

import 'package:flutter_cached/flutter_cached.dart';
import 'package:hive/hive.dart';
import 'package:hpi_flutter/food/data/restaurant.dart';
import 'package:kt_dart/kt.dart';
import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart';

import 'entity.dart';

bool _isHiveInitialized = false;
const _rootCacheKey = '_root_';

class HiveCache {
  final String name;

  final Box<Children> _children;
  final LazyBox _data;

  static Future<HiveCache> create({
    @required Set<Type> types,
    String name = 'cache',
  }) async {
    assert(types != null);
    assert(types.isNotEmpty);
    assert(name != null);

    Box<Children> children;
    LazyBox data;

    await Future.wait([
      () async {
        children = await Hive.openBox('_children_${name}_',
            compactionStrategy: (a, b) => false);
        children.values.forEach((child) => child.retainTypes(types));
      }(),
      () async {
        data = await Hive.openBox(name,
            lazy: true, compactionStrategy: (a, b) => false);
      }(),
    ]);

    final cache = HiveCache._(name, children, data);
    await cache._collectGarbage();
    return cache;
  }

  HiveCache._(this.name, this._children, this._data);

  Future<void> _collectGarbage() async {
    final Set<String> usefulKeys = {};

    void markAsUseful(String key) {
      if (usefulKeys.contains(key)) return;
      usefulKeys.add(key);
      for (final child in _children.get(key)?.getAllChildren() ?? []) {
        markAsUseful(child);
      }
    }

    markAsUseful(_rootCacheKey);

    // Remove all the non-useful entries.
    final nonUsefulKeys = _data.keys.toSet().difference(usefulKeys);
    await Future.wait([
      _children.deleteAll(nonUsefulKeys),
      _data.deleteAll(nonUsefulKeys),
    ]);
  }

  Future<void> putChildrenOfType<T extends Entity>(
      String parent, List<T> children) async {
    String key = parent ?? _rootCacheKey;
    Children theChildren = _children.get(key);
    if (theChildren == null) {
      await _children.put(key, Children());
      theChildren = _children.get(key);
    }

    await Future.wait(children.map((child) => _data.put(child.id, child)));
    theChildren.setChildrenOfType<T>(
        children.map((child) => child.id.toString()).toList());
  }

  Future<dynamic> get(String id) async {
    return await _data.get(id);
  }

  Future<List<T>> getChildrenOfType<T>(String parent) async {
    final String key = parent ?? _rootCacheKey;
    final List<String> childrenKeys =
        _children.get(key)?.getChildrenOfType<T>() ??
            (throw NotInCacheException());
    return [for (final key in childrenKeys) await _data.get(key)]
        .where((data) => data != null)
        .cast<T>()
        .toList();
  }

  Future<void> clear() => Future.wait([_data.clear(), _children.clear()]);
}

class Children extends HiveObject {
  /// Map from stringified runtime types to lists of ids.
  final Map<String, List<String>> _children = {};

  void setChildrenOfType<T>(List<String> children) {
    _children[T.toString()] = children;
    save();
  }

  List<String> getChildrenOfType<T>() {
    return _children[T.toString()] ?? (throw NotInCacheException());
  }

  Set<String> getAllChildren() {
    return _children.values.reduce((a, b) => [...a, ...b]).toSet();
  }

  void retainTypes(Set<Type> types) {
    final typesAsStrings = types.map((type) => type.toString()).toSet();
    _children.removeWhere((key, _) => !typesAsStrings.contains(key));
    if (_children.isEmpty) {
      delete();
    } else {
      save();
    }
  }
}

class ChildrenAdapter extends TypeAdapter<Children> {
  @override
  Children read(BinaryReader reader) {
    return Children()
      .._children.addAll({
        for (final entry in (reader.read() as Map)?.entries ?? [])
          entry.key: (entry.value as List).cast<String>(),
      });
  }

  @override
  void write(BinaryWriter writer, Children obj) {
    writer.write(obj._children);
  }
}

class ColorAdapter extends TypeAdapter<Color> {
  @override
  Color read(BinaryReader reader) => Color(reader.readInt());

  @override
  void write(BinaryWriter writer, Color color) => writer.writeInt(color.value);
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

Future<void> initializeHive() async {
  if (_isHiveInitialized) return;
  _isHiveInitialized = true;

  var dir = await getApplicationDocumentsDirectory();

  Hive
    ..init(dir.path)
    // General:
    ..registerAdapter(ColorAdapter(), 48)
    ..registerAdapter(ChildrenAdapter(), 49)
    // App module:
    ..registerAdapter(MenuItemAdapter(), 50)
    ..registerAdapter(RestaurantAdapter(), 51)
    ..registerAdapter(LabelAdapter(), 52);
}
