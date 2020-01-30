import 'package:flutter/foundation.dart';
import 'package:flutter_cached/flutter_cached.dart';
import 'package:kt_dart/kt.dart';

@immutable
class PaginatedController<T> extends CacheController<KtList<T>> {
  PaginatedController({
    @required Future<T> Function() fetcher,
    @required Future<void> Function(T data) saveToCache,
    @required Future<T> Function() loadFromCache,
  });

  /// Call [fetch] like you normally would. Once data are there and you reach
  /// the end of it, you may call [fetchMore].
  @override
  Future<void> fetchMore() {
    return null;
  }

  @override
  // TODO: implement updates
  Stream<CacheUpdate<KtList<T>>> get updates => null;
}

@immutable
class Paginated<T> extends StatelessWidget {
  Paginated({
    this.pageSize = 20,
    @required this.dataLoader,
    @required this.builder,
    @required this.itemBuilder,
  })  : assert(dataLoader != null),
        assert(builder != null),
        assert(itemBuilder != null);

  final KtMutableMap<int, String> _tokens = KtMutableMap.from({0: ''});
  final int pageSize;
  final PaginationDataLoader<T> dataLoader;
  final Widget Function(PagewiseLoadController<T> controller) builder;
  final ItemBuilder<T> itemBuilder;

  @override
  Widget build(BuildContext context) {
    return builder(PagewiseLoadController<T>(
      pageSize: pageSize,
      pageFuture: (page) async {
        assert(_tokens.containsKey(page));
        if (page > 0 && _tokens[page] == null) return [];

        final res = await dataLoader(
          pageSize: pageSize,
          pageToken: _tokens[page],
        );
        _tokens[page + 1] = res.nextPageToken;
        return res.items.asList();
      },
    ));
  }
}
