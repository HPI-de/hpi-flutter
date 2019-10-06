import 'package:flutter/foundation.dart';
import 'package:grpc/grpc.dart';
import 'package:hpi_flutter/core/data/utils.dart';
import 'package:hpi_flutter/hpi_cloud_apis/hpi/cloud/food/v1test/food_service.pbgrpc.dart';
import 'package:kt_dart/collection.dart';

import 'restaurant.dart';

@immutable
class FoodBloc {
  final FoodServiceClient _client;

  FoodBloc(Uri serverUrl)
      : assert(serverUrl != null),
        _client = FoodServiceClient(
          ClientChannel(
            serverUrl.toString(),
            port: 50065,
            options: ChannelOptions(
              credentials: ChannelCredentials.insecure(),
            ),
          ),
        );

  Stream<KtList<MenuItem>> getMenuItems({String restaurantId}) {
    final req = ListMenuItemsRequest()..date = dateTimeToDate(DateTime.now());
    if (restaurantId != null) req.restaurantId = restaurantId;

    return Stream.fromFuture(_client.listMenuItems(req))
        .map((r) => KtList.from(r.items).map((i) => MenuItem.fromProto(i)));
  }

  Stream<MenuItem> getMenuItem(String id) {
    assert(id != null);
    return Stream.fromFuture(_client.getMenuItem(GetMenuItemRequest()..id = id))
        .map((a) => MenuItem.fromProto(a));
  }

  Stream<Restaurant> getRestaurant(String id) {
    assert(id != null);
    return Stream.fromFuture(
            _client.getRestaurant(GetRestaurantRequest()..id = id))
        .map((s) => Restaurant.fromProto(s));
  }

  Stream<Label> getLabel(String id) {
    assert(id != null);
    return Stream.fromFuture(_client.getLabel(GetLabelRequest()..id = id))
        .map((s) => Label.fromProto(s));
  }
}
