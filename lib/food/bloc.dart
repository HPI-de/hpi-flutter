import 'package:flutter/foundation.dart';
import 'package:grpc/service_api.dart';
import 'package:hpi_flutter/hpi_cloud_apis/hpi/cloud/food/v1test/food_service.pbgrpc.dart';
import 'package:kt_dart/collection.dart';

import 'data/restaurant.dart';

@immutable
class FoodBloc {
  final FoodServiceClient _client;

  FoodBloc(Uri serverUrl)
      : assert(serverUrl != null),
        _client = null
  /* TODO: do this and not the above
      : assert(channel != null),
        _client = FoodServiceClient(channel)*/
  ;

  Stream<KtList<MenuItem>> getMenuItems() async* {
    // TODO: don't use dummy data
    yield KtList.from([
      MenuItem(
        id: "mensa1",
        date: DateTime.now(),
        restaurantId: "mensa",
        title: "Vegane Nudeln all' arrabbiata, dazu Reibekäse",
        substitution: Substitution(title: "andere Nudeln"),
        prices: {"student": 1.40},
        counter: "1",
        labelIds: setOf("chicken", "beef", "vegetarian"),
      ),
      MenuItem(
        id: "mensa2",
        date: DateTime.now(),
        restaurantId: "mensa",
        title:
            "Tandem Marburg: Kassler-Rippenspeer mit Honigkruste, Apfelweinsauerkraut und Kartoffelbrei",
        substitution: Substitution(title: "nur Honigkruste"),
        prices: {"student": 2.00},
        counter: "2",
        labelIds: setOf("chicken", "beef", "pork"),
      ),
      MenuItem(
        id: "mensa3",
        date: DateTime.now(),
        restaurantId: "mensa",
        title:
            "Rinderhacksteak mit Knoblauchdip und Peperoni-Schoten, dazu bunter CousCous-Salat oder griechiche Kartoffeln",
        substitution: null,
        prices: {"student": 2.50},
        counter: "3",
        labelIds: setOf("chicken", "beef"),
      ),
      MenuItem(
        id: "mensa4",
        date: DateTime.now(),
        restaurantId: "mensa",
        title:
            "Brokkoli-Nuss-Ecke mit rustikalem Möhrengemüse und Schupfnudeln oder Kartoffeln",
        substitution: Substitution(
            title:
                "Blumenkohl-Marzipan-Kante mit feinem Karottenobst oder Schlöpfreis und Anti-Kartoffeln"),
        prices: {"student": 2.50},
        counter: "4",
        labelIds: setOf("chicken", "beef", "vegetarian"),
      ),
      MenuItem(
        id: "mensaSoup",
        date: DateTime.now(),
        restaurantId: "mensa",
        title: "Tandem Marbug: Quer durch en Gadde (Gemüsecremesuppe)",
        substitution: Substitution(title: "nur Brühe"),
        prices: {"student": 1.00},
        counter: "S",
        labelIds: setOf("chicken", "beef", "vegetarian"),
      ),
      MenuItem(
        id: "mensaNoodles",
        date: DateTime.now(),
        restaurantId: "mensa",
        title: "Nudeln mit veganer Tomatensauce oder Hackfleischsauce",
        substitution: Substitution(title: "mehr Hack"),
        prices: {"student": 2.00},
        counter: "N",
        labelIds: setOf("chicken", "beef", "pork"),
      ),
      MenuItem(
        id: "ulf1",
        date: DateTime.now(),
        restaurantId: "ulf",
        title: "Hühnerfrikassee mit Reis",
        substitution: null,
        prices: {"student": 5.00},
        counter: "T",
        labelIds: emptySet(),
      ),
      MenuItem(
          id: "ulf2",
          date: DateTime.now(),
          restaurantId: "ulf",
          title: "Nudelsalat mit einer Ruccolapesto und Mozzarella",
          substitution: null,
          prices: {"student": 5.00},
          counter: "T",
          labelIds: emptySet()),
      MenuItem(
        id: "ulf3",
        date: DateTime.now(),
        restaurantId: "ulf",
        title: "Nudelsalat mit einer Tomatenpesto und Mozzarella",
        substitution: null,
        prices: {"student": 5.00},
        counter: "T",
        labelIds: emptySet(),
      ),
      MenuItem(
        id: "ulf4",
        date: DateTime.now(),
        restaurantId: "ulf",
        title: "Minestrone",
        substitution: null,
        prices: {"student": 3.00},
        counter: "T",
        labelIds: emptySet(),
      ),
    ]);
    /*return Stream.fromFuture(_client.listMenuItems(ListMenuItemsRequest()))
        .map((r) => KtList.from(r.items).map((i) => MenuItem.fromProto(i)));*/
  }

  Stream<MenuItem> getMenuItem(String id) {
    assert(id != null);
    return Stream.fromFuture(_client.getMenuItem(GetMenuItemRequest()..id = id))
        .map((a) => MenuItem.fromProto(a));
  }

  Stream<Restaurant> getRestaurant(String id) async* {
    // TODO: don't use dummy data
    assert(id != null);
    if (id == 'mensa')
      yield Restaurant(id: 'mensa', title: 'Mensa');
    else
      yield Restaurant(id: 'ulf', title: "Ulf's Cafe");
    /*return Stream.fromFuture(
            _client.getRestaurant(GetRestaurantRequest()..id = id))
        .map((s) => Restaurant.fromProto(s));*/
  }

  Stream<Label> getLabel(String id) async* {
    assert(id != null);
    // TODO: don't use dummy data
    yield Label(id: 'something', title: 'something', icon: 'icon');
    /*return Stream.fromFuture(_client.getLabel(GetLabelRequest()..id = id))
        .map((s) => Label.fromProto(s));*/
  }
}
