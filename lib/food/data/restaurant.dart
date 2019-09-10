import 'package:hpi_flutter/core/data/utils.dart';
import 'package:hpi_flutter/hpi_cloud_apis/hpi/cloud/food/v1test/restaurant.pb.dart'
    as proto;
import 'package:kt_dart/collection.dart';
import 'package:meta/meta.dart';

@immutable
class Restaurant {
  final String id;
  final String title;

  const Restaurant({@required this.id, @required this.title})
      : assert(id != null),
        assert(title != null);

  Restaurant.fromProto(proto.Restaurant restaurant)
      : this(
          id: restaurant.id,
          title: restaurant.title,
        );
  proto.Restaurant toProto() {
    return proto.Restaurant()
      ..id = id
      ..title = title;
  }
}

@immutable
class MenuItem {
  final String id;
  final String restaurantId;
  final DateTime date;
  final String title;
  final Substitution substitution;
  final Map<String, double> prices;
  final String counter;
  final KtSet<String> labelIds;

  const MenuItem({
    @required this.id,
    @required this.restaurantId,
    @required this.date,
    @required this.title,
    @required this.substitution,
    @required this.prices,
    @required this.counter,
    @required this.labelIds,
  });

  MenuItem.fromProto(proto.MenuItem item)
      : this(
          id: item.id,
          restaurantId: item.restaurantId,
          date: dateToDateTime(item.date),
          title: item.title,
          substitution: Substitution.fromProto(item.substitution),
          prices: {
            for (var type in item.prices.keys)
              type: moneyToDouble(item.prices[type])
          },
          counter: item.counter,
          labelIds: KtSet.from(item.labelIds),
        );
  proto.MenuItem toProto() {
    return proto.MenuItem()
      ..id = id
      ..restaurantId = restaurantId
      ..date = dateTimeToDate(date)
      ..title = title
      ..substitution = substitution.toProto()
      ..prices.addAll(
          {for (var type in prices.keys) type: doubleToMoney(prices[type])})
      ..counter = counter
      ..labelIds.addAll(labelIds.iter);
  }
}

@immutable
class Substitution {
  final String title;
  final KtList<String> labelIds;

  Substitution({
    this.title,
    this.labelIds,
  });

  Substitution.fromProto(proto.MenuItem_Substitution substitution)
      : this(
          title: substitution.title,
          labelIds: KtList.from(substitution.labelIds),
        );

  proto.MenuItem_Substitution toProto() {
    return proto.MenuItem_Substitution()
      ..title = title
      ..labelIds.addAll(labelIds.asList());
  }
}

@immutable
class Label {
  final String id;
  final String title;
  final String icon;

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
  proto.Label toProto() {
    return proto.Label()
      ..id = id
      ..title = title
      ..icon = icon;
  }
}
