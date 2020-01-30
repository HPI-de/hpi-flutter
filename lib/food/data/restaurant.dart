import 'package:hive/hive.dart';
import 'package:hpi_flutter/core/data/entity.dart';
import 'package:hpi_flutter/core/data/hive.dart';
import 'package:hpi_flutter/core/data/utils.dart';
import 'package:hpi_flutter/hpi_cloud_apis/hpi/cloud/food/v1test/food.pb.dart'
    as proto;
import 'package:kt_dart/collection.dart';
import 'package:meta/meta.dart';

part 'restaurant.g.dart';

@immutable
@HiveType(typeId: TypeId.typeRestaurant)
class Restaurant extends Entity<Restaurant> {
  @HiveField(1)
  final String title;

  const Restaurant({
    @required Id<Restaurant> id,
    @required this.title,
  })  : assert(id != null),
        assert(title != null),
        super(id);

  Restaurant.fromProto(proto.Restaurant restaurant)
      : this(
          id: Id<Restaurant>(restaurant.id),
          title: restaurant.title,
        );
  proto.Restaurant toProto() {
    return proto.Restaurant()
      ..id = id.id
      ..title = title;
  }
}

@immutable
@HiveType(typeId: TypeId.typeMenuItem)
class MenuItem extends Entity<MenuItem> {
  @HiveField(1)
  final String restaurantId;

  @HiveField(2)
  final DateTime date;

  @HiveField(3)
  final String title;

  @HiveField(4)
  final Map<String, double> prices;

  @HiveField(5)
  final String counter;

  @HiveField(6)
  final KtSet<String> labelIds;

  const MenuItem({
    @required Id<MenuItem> id,
    @required this.restaurantId,
    @required this.date,
    @required this.title,
    @required this.prices,
    @required this.counter,
    @required this.labelIds,
  }) : super(id);

  MenuItem.fromProto(proto.MenuItem item)
      : this(
          id: Id<MenuItem>(item.id),
          restaurantId: item.restaurantId,
          date: dateToDateTime(item.date),
          title: item.title,
          prices: {
            for (var type in item.prices.keys)
              type: moneyToDouble(item.prices[type])
          },
          counter: item.counter,
          labelIds: KtSet.from(item.labelIds),
        );
  proto.MenuItem toProto() {
    return proto.MenuItem()
      ..id = id.id
      ..restaurantId = restaurantId
      ..date = dateTimeToDate(date)
      ..title = title
      ..prices.addAll(
          {for (var type in prices.keys) type: doubleToMoney(prices[type])})
      ..counter = counter
      ..labelIds.addAll(labelIds.iter);
  }
}

@immutable
@HiveType(typeId: TypeId.typeLabel)
class Label extends Entity<Label> {
  @HiveField(1)
  final String title;

  @HiveField(2)
  final String icon;

  const Label({
    @required Id<Label> id,
    @required this.title,
    @required this.icon,
  })  : assert(id != null),
        assert(title != null),
        assert(icon != null),
        super(id);

  Label.fromProto(proto.Label label)
      : this(
          id: Id<Label>(label.id),
          title: label.title,
          icon: label.icon,
        );
  proto.Label toProto() {
    return proto.Label()
      ..id = id.id
      ..title = title
      ..icon = icon;
  }
}
