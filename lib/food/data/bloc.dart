import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_cached/flutter_cached.dart';
import 'package:grpc/grpc.dart';
import 'package:hpi_flutter/app/services/storage.dart';
import 'package:hpi_flutter/core/data/utils.dart';
import 'package:hpi_flutter/core/utils.dart';
import 'package:hpi_flutter/hpi_cloud_apis/hpi/cloud/food/v1test/food_service.pbgrpc.dart';
import 'package:hpi_flutter/hpi_cloud_apis/hpi/cloud/food/v1test/food.pb.dart'
    as proto;
import 'package:kt_dart/collection.dart';
import 'package:meta/meta.dart';

import 'restaurant.dart';

@immutable
class FoodBloc {
  FoodBloc._({
    @required this.storage,
    @required this.client,
  });

  final StorageService storage;
  final FoodServiceClient client;

  factory FoodBloc(StorageService storage, Uri serverUrl, Locale locale) {
    assert(serverUrl != null);
    assert(locale != null);

    return FoodBloc._(
      storage: storage,
      client: FoodServiceClient(
        ClientChannel(
          serverUrl.toString(),
          port: 50065,
          options: ChannelOptions(credentials: ChannelCredentials.insecure()),
        ),
        options: createCallOptions(locale),
      ),
    );
  }

  CacheController<KtList<MenuItem>> fetchMenuItems() => fetchList(
        storage: storage,
        download: () async {
          final req = ListMenuItemsRequest()
            ..date = dateTimeToDate(DateTime.now());
          return (await client.listMenuItems(req)).items;
        },
        parser: (data) => MenuItem.fromProto(data),
      );

  CacheController<KtList<Restaurant>> fetchRestaurants() => fetchList(
        storage: storage,
        download: () async =>
            (await client.listRestaurants(ListRestaurantsRequest()))
                .restaurants,
        parser: (data) => Restaurant.fromProto(data),
      );

  CacheController<KtList<Label>> fetchLabels() => fetchList(
        storage: storage,
        download: () async =>
            (await client.listLabels(ListLabelsRequest())).labels,
        parser: (data) => Label.fromProto(data),
      );

  //Stream<Label> getLabel(String id) => getItemWithId(labels, id);

  //Stream<Restaurant> getRestaurant(String id) => getItemWithId(restaurants, id);
}
