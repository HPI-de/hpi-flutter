import 'package:flutter/material.dart';
import 'package:flutter_cached/flutter_cached.dart';
import 'package:hive/hive.dart';
import 'package:kt_dart/kt.dart';

import 'entity.dart';
import 'hive.dart';

class NotInCacheException {}

bool _isHiveInitialized = false;
const rootId = '_root_';

/// A function that determines whether compaction should happen for Hive
/// entries [a] and [b]. For now, compaction should never happen because of an
/// issue with compaction.
final noCompaction = (dynamic a, dynamic b) => false;

/// Allows caching entities. One entity can relate to other entities and each
/// relation has a name. For example, a news article might relate to a user in
/// a relation named "author" and to a list of in a relation named "readers".
/// There is one virtual root entity. All entities need to be transitively
/// referenced by it – otherwise, they'll get deleted on the next app startup.
class HiveCache {
  HiveCache._(this._children, this._data);

  /// This box maps ids of entities to their relations.
  final Box<Relations> _children;

  /// The actual entities.
  final Box<dynamic> _data;

  static Future<HiveCache> create() async {
    Box<Relations> children;
    Box<dynamic> data;

    await Future.wait([
      () async {
        children = await Hive.openBox(
          'children',
          compactionStrategy: noCompaction,
        );
      }(),
      () async {
        data = await Hive.openBox(
          'data',
          compactionStrategy: noCompaction,
        );
      }(),
    ]);

    final cache = HiveCache._(children, data);
    await cache._collectGarbage();
    return cache;
  }

  /// During startup of the app, we throw out all the entities that are no
  /// longer referenced by the root entity.
  Future<void> _collectGarbage() async {
    final Set<String> usefulKeys = {};

    void markAsUseful(String key) {
      if (usefulKeys.contains(key)) return;
      usefulKeys.add(key);
      for (final child in _children.get(key)?.getAllReferences() ?? []) {
        markAsUseful(child);
      }
    }

    markAsUseful(rootId);

    // Remove all the non-useful entries.
    final nonUsefulKeys = _data.keys.toSet().difference(usefulKeys);
    await Future.wait([
      _children.deleteAll(nonUsefulKeys),
      _data.deleteAll(nonUsefulKeys),
    ]);
  }

  /// Creates references to the given [references] from the entity with the
  /// [parentId]. The relation has the given [name].
  Future<void> putReferences<T extends Entity<T>>({
    String parentId = rootId,
    @required String name,
    @required List<T> references,
  }) async {
    assert(parentId != null);
    Relations theChildren = _children.get(parentId);

    if (theChildren == null) {
      /// This relation didn't exist yet, so create a new [Children] object for
      /// that entity. Note that we first put the children into the box and
      /// then retrieve it again, so that we get an active [HiveObject], which
      /// we can [save] and [delete], because it has a reference to the box
      /// it's saved to.
      await _children.put(parentId, Relations());
      theChildren = _children.get(parentId);
    }

    await Future.wait(references.map((child) => _data.put(child.id, child)));
    theChildren.setReferences<T>(
      name,
      references.map((child) => child.id.toString()).toList(),
    );
  }

  /// Retrieves the entities which the entity with the [parentId] refers to
  /// with the relation [name].
  List<T> getReferences<T extends Entity<T>>({
    String parentId = rootId,
    @required String name,
  }) {
    assert(parentId != null);
    final List<String> childrenKeys =
        _children.get(parentId)?.getReferences<T>(name) ??
            (throw NotInCacheException());

    return [for (final key in childrenKeys) _data.get(key)]
        .where((data) => data != null)
        .cast<T>()
        .toList();
  }

  /// Creates a reference to the single [reference] from the entity with the
  /// [parentId]. The relation has the given [name].
  Future<void> putReference<T extends Entity<T>>({
    String parentId = rootId,
    @required String name,
    @required T reference,
  }) async {
    putReferences(parentId: parentId, name: name, references: [reference]);
  }

  /// Retrieves the single entity which the entity with the [parentId] refers
  /// to with the relation [name].
  T getReference<T extends Entity<T>>({
    String parentId = rootId,
    @required String name,
  }) {
    return getReferences<T>(parentId: parentId, name: name).single;
  }

  /// Retrieves the entity with the [id].
  T get<T extends Entity<T>>(String id) {
    return _data.get(id) as T;
  }

  Future<void> clear() => Future.wait([_data.clear(), _children.clear()]);
}

class Relations extends HiveObject {
  /// Map from relation name to lists of ids of referenced entities.
  final Map<String, List<String>> _refs = {};

  void setReferences<T>(String role, List<String> references) {
    _refs[role] = references;
    save();
  }

  List<String> getReferences<T>(String role) {
    return _refs[role] ?? (throw NotInCacheException());
  }

  Set<String> getAllReferences() {
    return _refs.values.reduce((a, b) => [...a, ...b]).toSet();
  }

  void retainTypes(Set<Type> types) {
    final typesAsStrings = types.map((type) => type.toString()).toSet();
    _refs.removeWhere((key, _) => !typesAsStrings.contains(key));

    if (_refs.isEmpty) {
      delete();
    } else {
      save();
    }
  }
}

class RelationsAdapter extends TypeAdapter<Relations> {
  @override
  int get typeId => TypeId.typeRelations;

  @override
  Relations read(BinaryReader reader) {
    return Relations()
      .._refs.addAll({
        for (final entry in (reader.read() as Map)?.entries ?? [])
          entry.key: (entry.value as List).cast<String>(),
      });
  }

  @override
  void write(BinaryWriter writer, Relations obj) {
    writer.write(obj._refs);
  }
}
