import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_cached/flutter_cached.dart';
import 'package:grpc/grpc.dart';
import 'package:hpi_flutter/core/data/hive_cache_controller.dart';
import 'package:hpi_flutter/core/data/utils.dart';
import 'package:hpi_flutter/hpi_cloud_apis/hpi/cloud/food/v1test/food_service.pbgrpc.dart';
import 'package:hpi_flutter/hpi_cloud_apis/hpi/cloud/food/v1test/food.pb.dart'
    as proto;
import 'package:kt_dart/collection.dart';
import 'package:meta/meta.dart';

import 'restaurant.dart';

@immutable
class FoodBloc {
  final CacheController<KtList<MenuItem>> menuItems;
  final CacheController<KtList<Restaurant>> restaurants;
  final CacheController<KtList<Label>> labels;

  factory FoodBloc(Uri serverUrl, Locale locale) {
    assert(serverUrl != null);
    assert(locale != null);

    final client = FoodServiceClient(
      ClientChannel(
        serverUrl.toString(),
        port: 50065,
        options: ChannelOptions(credentials: ChannelCredentials.insecure()),
      ),
      options: createCallOptions(locale),
    );
    final menuItems = HiveCacheController(
      name: 'menuItems',
      fetcher: grpcCollectionDownloader<MenuItem, proto.MenuItem>(
        download: () async {
          final req = ListMenuItemsRequest()
            ..date = dateTimeToDate(DateTime.now());
          return (await client.listMenuItems(req)).items;
        },
        toProto: (proto) => MenuItem.fromProto(proto),
      ),
    );
    final restaurants = HiveCacheController<Restaurant>(
      name: 'restaurants',
      fetcher: grpcCollectionDownloader<Restaurant, proto.Restaurant>(
        download: () async =>
            (await client.listRestaurants(ListRestaurantsRequest()))
                .restaurants,
        toProto: (proto) => Restaurant.fromProto(proto),
      ),
    );
    final labels = HiveCacheController<Label>(
      name: 'labels',
      fetcher: grpcCollectionDownloader<Label, proto.Label>(
        download: () async =>
            (await client.listLabels(ListLabelsRequest())).labels,
        toProto: (proto) => Label.fromProto(proto),
      ),
    )..fetch();
    return FoodBloc._(
      menuItems: menuItems,
      restaurants: restaurants,
      labels: labels,
    );
  }

  FoodBloc._({
    @required this.menuItems,
    @required this.restaurants,
    @required this.labels,
  });

  Stream<Label> getLabel(String id) => getItemWithId(labels, id);

  Stream<Restaurant> getRestaurant(String id) => getItemWithId(restaurants, id);
}
