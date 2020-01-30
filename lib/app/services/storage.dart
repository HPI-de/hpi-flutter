import 'package:flutter/widgets.dart';
import 'package:hpi_flutter/core/data/cache.dart';
import 'package:provider/provider.dart';

/// A service that offers storage of app-wide data.
class StorageService {
  StorageService._(this.cache);

  final HiveCache cache;

  /// Opens all the boxes.
  static Future<StorageService> create() async {
    return StorageService._(await HiveCache.create());
  }

  static StorageService of(BuildContext context) =>
      Provider.of<StorageService>(context);

  Future<void> clear() => cache.clear();
}
