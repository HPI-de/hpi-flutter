import 'package:flutter/widgets.dart';
import 'package:hpi_flutter/core/data/hive.dart';
import 'package:hpi_flutter/food/data/restaurant.dart';
import 'package:provider/provider.dart';

/// A service that offers storage of app-wide data.
class StorageService {
  StorageService._(this.cache);

  final HiveCache cache;

  static Future<StorageService> create() async {
    HiveCache cache = await HiveCache.create(types: {
      Restaurant,
      MenuItem,
    });

    return StorageService._(cache);
  }

  static StorageService of(BuildContext context) =>
      Provider.of<StorageService>(context);

  Future<void> clear() => cache.clear();
}
