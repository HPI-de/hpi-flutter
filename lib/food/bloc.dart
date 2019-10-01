import 'package:flutter/foundation.dart';
import 'package:grpc/grpc.dart';
import 'package:hpi_flutter/core/data/utils.dart';
import 'package:hpi_flutter/hpi_cloud_apis/hpi/cloud/food/v1test/food_service.pbgrpc.dart';
import 'package:kt_dart/collection.dart';

import 'data/restaurant.dart';

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

  Stream<KtList<MenuItem>> getMenuItems() {
    return Stream.fromFuture(_client.listMenuItems(
            ListMenuItemsRequest()..date = dateTimeToDate(DateTime.now())))
        .map((r) => KtList.from(r.items).map((i) => MenuItem.fromProto(i)));
  }

  Stream<MenuItem> getMenuItem(String id) {
    assert(id != null);
    return Stream.fromFuture(_client.getMenuItem(GetMenuItemRequest()..id = id))
        .map((a) => MenuItem.fromProto(a));
  }

  Stream<Restaurant> getRestaurant(String id) {
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
