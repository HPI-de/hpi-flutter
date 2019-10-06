import 'package:cached_listview/cached_listview.dart';
import 'package:grpc/grpc.dart';
import 'package:hpi_flutter/core/data/grpc_downloader.dart';
import 'package:hpi_flutter/hpi_cloud_apis/hpi/cloud/food/v1test/food_service.pbgrpc.dart';
import 'package:hpi_flutter/hpi_cloud_apis/hpi/cloud/food/v1test/food.pb.dart'
    as proto;
import 'package:repository/repository.dart';
import 'package:meta/meta.dart';
import 'package:repository_hive/repository_hive.dart';

import 'data/restaurant.dart';

@immutable
class FoodBloc {
  final FoodServiceClient client;
  final CacheController<MenuItem> menuItems;
  final Repository<Restaurant> restaurants;
  final Repository<Label> labels;

  FoodBloc._({
    @required this.client,
    @required this.menuItems,
    @required this.restaurants,
    @required this.labels,
  });

  factory FoodBloc(Uri serverUrl) {
    final client = FoodServiceClient(
      ClientChannel(
        serverUrl.toString(),
        port: 50065,
        options: ChannelOptions(credentials: ChannelCredentials.insecure()),
      ),
    );

    final menuItemsCache = HiveRepository<MenuItem>('menu_items');
    final menuItems = CacheController(
        fetcher: () async =>
            (await client.listMenuItems(ListMenuItemsRequest()))
                .items
                .map((item) => MenuItem.fromProto(item)),
        loadFromCache: () => menuItemsCache.fetchAllItems().first,
        saveToCache: (items) async {
          for (var item in items) menuItemsCache.update(item.id, item);
        });

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
