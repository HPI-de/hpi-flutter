import 'package:flutter/foundation.dart';
import 'package:grpc/grpc.dart';
import 'package:hpi_flutter/app/app.dart';
import 'package:hpi_flutter/core/core.dart';
import 'package:hpi_flutter/hpi_cloud_apis/hpi/cloud/food/v1test/food_service.pbgrpc.dart';
import 'package:kt_dart/collection.dart';
import 'package:time_machine/time_machine.dart';

import 'data.dart';

@immutable
class FoodBloc {
  FoodBloc()
      : _client = FoodServiceClient(
          ClientChannel(
            services.get<Uri>().toString(),
            port: 50065,
            options: ChannelOptions(
              credentials: ChannelCredentials.insecure(),
            ),
          ),
          options: createCallOptions(),
        );

  final FoodServiceClient _client;

  Stream<KtList<MenuItem>> getMenuItems({String restaurantId}) {
    final req = ListMenuItemsRequest()..date = LocalDate.today().toDate();
    if (restaurantId != null) {
      req.restaurantId = restaurantId;
    }

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
