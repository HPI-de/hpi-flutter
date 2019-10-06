import 'package:flutter/widgets.dart';
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
        ).first;
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

typedef PaginationDataLoader<T> = Stream<PaginationResponse<T>> Function({
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
