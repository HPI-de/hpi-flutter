import 'package:flutter_cached/flutter_cached.dart';
import 'package:hpi_flutter/app/services/storage.dart';
import 'package:kt_dart/collection.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:meta/meta.dart';

import 'data/entity.dart';

bool isNullOrBlank(String string) {
  return string == null || string.trim().isEmpty;
}

KtList<T> toKtList<T>(Iterable<T> iterable) => KtList.from(iterable);

KtList<T> valuesToKtList<T>(Map<dynamic, T> map) => KtList.from(map.values);

String enumToString(Object enumValue) {
  if (enumValue == null) return null;

  final string = enumValue.toString();
  return string.substring(string.indexOf('.') + 1);
}

E stringToEnum<E>(String value, List<E> enumValues) {
  if (value == null) return null;
  assert(enumValues != null);

  return enumValues.firstWhere(
    (v) => enumToString(v) == value,
    orElse: () => null,
  );
}

Future<bool> tryLaunch(String urlString) async {
  if (await canLaunch(urlString)) return launch(urlString);
  return false;
}

/*CacheController<T> fetchSingle<T extends Entity, ProtoType>({
  @required StorageService storage,
  String parentId,
  @required String name,
  @required Future<ProtoType> Function() download,
  @required T Function(ProtoType data) parser,
}) {
  assert(storage != null);
  return CacheController<T>(
    saveToCache: (item) => storage.cache.putReference(parentId: parentId, ),
    loadFromCache: () async {
      return (await cache.box<T>(parent)).singleWhere(
        (_) => true,
        orElse: () => (throw NotInCacheException()),
      );
    },
    fetcher: () async {
      return parser(await download());
    },
  );
}

CacheController<KtList<T>> fetchList<T extends Entity, ProtoType>({
  @required HiveCache<T> cache,
  String parent,
  @required Future<List<ProtoType>> Function() download,
  @required T Function(ProtoType data) parser,
}) {
  assert(cache != null);
  return CacheController<KtList<T>>(
    saveToCache: (items) => cache.box.putAll({
      for (final item in items.iter) item.id: item,
    }),
    loadFromCache: () async =>
        KtList.from(await cache.<T>(parent)),
    fetcher: () async {
      return KtList.from(await download()).map(parser);
    },
  );
}*/
