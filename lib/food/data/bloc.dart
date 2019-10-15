import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_cached/flutter_cached.dart';
import 'package:grpc/grpc.dart';
import 'package:hpi_flutter/core/data/grpc_downloader.dart';
import 'package:hpi_flutter/core/data/utils.dart';
import 'package:hpi_flutter/hpi_cloud_apis/hpi/cloud/food/v1test/food_service.pbgrpc.dart';
import 'package:hpi_flutter/hpi_cloud_apis/hpi/cloud/food/v1test/food.pb.dart'
    as proto;
import 'package:repository/repository.dart';
import 'package:meta/meta.dart';
import 'package:repository_hive/repository_hive.dart';

import 'restaurant.dart';

@immutable
class FoodBloc {
  final FoodServiceClient _client;

  FoodBloc(Uri serverUrl, Locale locale)
      : assert(serverUrl != null),
        assert(locale != null),
        _client = FoodServiceClient(
          ClientChannel(
            serverUrl.toString(),
            port: 50065,
            options: ChannelOptions(
              credentials: ChannelCredentials.insecure(),
            ),
          ),
          options: createCallOptions(locale),
        );

  Stream<KtList<MenuItem>> getMenuItems({String restaurantId}) {
    final req = ListMenuItemsRequest()..date = dateTimeToDate(DateTime.now());
    if (restaurantId != null) req.restaurantId = restaurantId;

    return Stream.fromFuture(_client.listMenuItems(req))
        .map((r) => KtList.from(r.items).map((i) => MenuItem.fromProto(i)));
  }

  FoodBloc._({
    @required this.client,
    @required this.menuItems,
    @required this.restaurants,
    @required this.labels,
  });

  Stream<Restaurant> getRestaurant(String id) {
    assert(id != null);
    return Stream.fromFuture(
            _client.getRestaurant(GetRestaurantRequest()..id = id))
        .map((s) => Restaurant.fromProto(s));
  }

    final restaurants = CachedRepository<Restaurant>(
      strategy: CacheStrategy.alwaysFetchFromSource,
      cache: HiveRepository('restaurants'),
      source: GrpcDownloader<Restaurant, proto.Restaurant>(
        download: (id) => client.getRestaurant(GetRestaurantRequest()..id = id),
        toProto: (item) => Restaurant.fromProto(item),
      ),
    );

    final labels = CachedRepository<Label>(
      strategy: CacheStrategy.alwaysFetchFromSource,
      cache: InMemoryStorage(),
      source: GrpcDownloader<Label, proto.Label>(
        download: (id) => client.getLabel(GetLabelRequest()..id = id),
        toProto: (item) => Label.fromProto(item),
      ),
    );

    return FoodBloc._(
      client: client,
      menuItems: menuItems,
      restaurants: restaurants,
      labels: labels,
    );
  }

  Stream<Restaurant> getRestaurant(String id) => restaurants.fetch(Id(id));

  Stream<Label> getLabel(String id) => labels.fetch(Id(id));
}
