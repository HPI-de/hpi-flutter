import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_cached/flutter_cached.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:kt_dart/collection.dart';

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

@immutable
class PaginatedListView<T> extends Paginated<T> {
  PaginatedListView({
    Axis scrollDirection = Axis.vertical,
    EdgeInsetsGeometry padding,
    int pageSize = 20,
    @required PaginationDataLoader<T> dataLoader,
    @required ItemBuilder<T> itemBuilder,
  }) : super(
          pageSize: pageSize,
          dataLoader: dataLoader,
          builder: (controller) => PagewiseListView(
            scrollDirection: scrollDirection,
            pageLoadController: controller,
            itemBuilder: itemBuilder,
            padding: padding,
          ),
          itemBuilder: itemBuilder,
        );
}

@immutable
class PaginatedSliverList<T> extends Paginated<T> {
  PaginatedSliverList({
    int pageSize = 20,
    @required PaginationDataLoader<T> dataLoader,
    @required ItemBuilder<T> itemBuilder,
  }) : super(
          pageSize: pageSize,
          dataLoader: dataLoader,
          builder: (controller) => PagewiseSliverList(
            pageLoadController: controller,
            itemBuilder: itemBuilder,
          ),
          itemBuilder: itemBuilder,
        );
}

@immutable
class PaginatedSliverGrid<T> extends Paginated<T> {
  PaginatedSliverGrid.count({
    @required int crossAxisCount,
    int pageSize = 20,
    @required PaginationDataLoader<T> dataLoader,
    @required ItemBuilder<T> itemBuilder,
  }) : super(
          pageSize: pageSize,
          dataLoader: dataLoader,
          builder: (controller) => PagewiseSliverGrid.count(
            crossAxisCount: crossAxisCount,
            pageLoadController: controller,
            itemBuilder: itemBuilder,
          ),
          itemBuilder: itemBuilder,
        );
  PaginatedSliverGrid.extent({
    @required double maxCrossAxisExtent,
    double childAspectRatio = 1,
    double spacing = 0,
    double crossAxisSpacing,
    double mainAxisSpacing,
    int pageSize = 20,
    @required PaginationDataLoader<T> dataLoader,
    @required ItemBuilder<T> itemBuilder,
  }) : super(
          pageSize: pageSize,
          dataLoader: dataLoader,
          builder: (controller) => PagewiseSliverGrid.extent(
            maxCrossAxisExtent: maxCrossAxisExtent,
            childAspectRatio: childAspectRatio,
            crossAxisSpacing: crossAxisSpacing ?? spacing,
            mainAxisSpacing: mainAxisSpacing ?? spacing,
            pageLoadController: controller,
            itemBuilder: itemBuilder,
          ),
          itemBuilder: itemBuilder,
        );
}

typedef PaginationDataLoader<T> = Future<PaginationResponse<T>> Function({
  int pageSize,
  String pageToken,
});

@immutable
class PaginationResponse<T> {
  const PaginationResponse(this.items, this.nextPageToken)
      : assert(items != null),
        assert(nextPageToken != null);

  final KtList<T> items;
  final String nextPageToken;
}

class CachedPaginatedController<Item> {
  CachedPaginatedController(this.loader, {this.pageSize = 0})
      : assert(loader != null),
        assert(pageSize != null) {
    _items = [];
    _cachedItems = [];
  }

  final PaginationDataLoader<Item> loader;
  final int pageSize;

  List<Item> _items;
  List<Item> _cachedItems;

  String _nextPageToken;
  bool get canLoadMore => _nextPageToken != '';

  dynamic _error;

  final _updatesController = StreamController<PaginationUpdate>();
  Stream<PaginationUpdate> get updates => _updatesController.stream;

  void dispose() => _updatesController.close();

  Future<void> loadMore() async {
    assert(canLoadMore);

    try {
      final response =
          await loader(pageSize: pageSize, pageToken: _nextPageToken);
      _items.addAll(response.items.iter);
      _cachedItems.removeRange(0, response.items.size);
      _nextPageToken = response.nextPageToken;
      _error = null;
    } catch (e) {
      _error = e;
    }

    if (!canLoadMore) {
      _cachedItems.clear();
    }

    // TODO: cache

    _updatesController.add(PaginationUpdate(
      items: KtList.from(_items),
      cachedPreview: KtList.from(_cachedItems),
      error: _error,
    ));
  }

  Future<void> reload() async {
    _cachedItems = _items + _cachedItems.sublist(_items.length);
    _items.clear();
    await loadMore();
  }
}

@immutable
class PaginationUpdate<Item> {
  PaginationUpdate({
    @required this.items,
    @required this.cachedPreview,
    @required this.error,
  });

  final KtList<Item> items;
  final KtList<Item> cachedPreview;

  final dynamic error;
  bool get hasError => error != null;
}
