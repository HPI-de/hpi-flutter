import 'package:flutter/material.dart';
import 'package:flutter_cached/flutter_cached.dart';
import 'package:hive/hive.dart';
import 'package:kt_dart/kt.dart';

import 'cache.dart';

class Id<T extends Entity<T>> {
  const Id(this.id);

  final String id;

  T resolve(HiveCache cache) => cache.get(id);
}

/// A special kind of item that also carries its id.
@immutable
@HiveType(typeId: 0)
abstract class Entity<T extends Entity<T>> {
  const Entity(this.id);

  @HiveField(0)
  final Id<T> id;
}

extension CachedFetching on HiveCache {
  CacheController<T> fetchCachedSingle<T extends Entity<T>, ProtoType>({
    Id<dynamic> parent,
    @required String role,
    @required Future<ProtoType> Function() download,
    @required T Function(ProtoType data) parser,
  }) {
    assert(parent != null);

    return CacheController<T>(
      saveToCache: (item) => putReference<T>(
        parentId: parent?.id ?? rootId,
        name: role,
        reference: item,
      ),
      loadFromCache: () async => getReference<T>(
        parentId: parent?.id ?? rootId,
        name: role,
      ),
      fetcher: () async => parser(await download()),
    );
  }

  CacheController<KtList<T>> fetchCachedList<T extends Entity<T>, ProtoType>({
    Id<dynamic> parent,
    @required String role,
    @required Future<List<ProtoType>> Function() download,
    @required T Function(ProtoType data) parser,
  }) {
    return CacheController<KtList<T>>(
      saveToCache: (items) => putReferences(
        parentId: parent?.id ?? rootId,
        name: role,
        references: items.asList(),
      ),
      loadFromCache: () async => KtList.from(getReferences(
        parentId: parent?.id ?? rootId,
        name: role,
      )),
      fetcher: () async => KtList.from(await download()).map(parser),
    );
  }
}
