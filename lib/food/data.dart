import 'package:hpi_flutter/core/core.dart';
import 'package:hpi_flutter/hpi_cloud_apis/hpi/cloud/food/v1test/food.pb.dart'
    as proto;
import 'package:meta/meta.dart';
import 'package:time_machine/time_machine.dart';

@immutable
class Restaurant {
  const Restaurant({@required this.id, @required this.title})
      : assert(id != null),
        assert(title != null);

  Restaurant.fromProto(proto.Restaurant restaurant)
      : this(
          id: restaurant.id,
          title: restaurant.title,
        );

  final String id;
  final String title;

  proto.Restaurant toProto() {
    return proto.Restaurant()
      ..id = id
      ..title = title;
  }
}

@immutable
class MenuItem {
  const MenuItem({
    @required this.id,
    @required this.restaurantId,
    @required this.date,
    @required this.title,
    @required this.prices,
    @required this.counter,
    @required this.labelIds,
  });

  MenuItem.fromProto(proto.MenuItem item)
      : this(
          id: item.id,
          restaurantId: item.restaurantId,
          date: item.date.toLocalDate(),
          title: item.title,
          prices: {
            for (var type in item.prices.keys)
              type: moneyToDouble(item.prices[type])
          },
          counter: item.counter,
          labelIds: item.labelIds.toSet(),
        );

  final String id;
  final String restaurantId;
  final LocalDate date;
  final String title;
  final Map<String, double> prices;
  final String counter;
  final Set<String> labelIds;

  proto.MenuItem toProto() {
    return proto.MenuItem()
      ..id = id
      ..restaurantId = restaurantId
      ..date = date.toDate()
      ..title = title
      ..prices.addAll(
          {for (var type in prices.keys) type: doubleToMoney(prices[type])})
      ..counter = counter
      ..labelIds.addAll(labelIds);
  }
}

@immutable
class Label {
  const Label({@required this.id, @required this.title, @required this.icon})
      : assert(id != null),
        assert(title != null),
        assert(icon != null);

  Label.fromProto(proto.Label label)
      : this(
          id: label.id,
          title: label.title,
          icon: label.icon,
        );

  final String id;
  final String title;
  final String icon;

  proto.Label toProto() {
    return proto.Label()
      ..id = id
      ..title = title
      ..icon = icon;
  }
}
