import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hpi_flutter/app/widgets/dashboard_page.dart';
import 'package:collection/collection.dart' show groupBy;
import 'package:kt_dart/kt.dart';
import 'package:provider/provider.dart';

import '../data/restaurant.dart';
import '../bloc.dart';
import 'menu_item.dart';

@immutable
class RestaurantMenu extends StatelessWidget {
  final String restaurantId;
  final KtList<MenuItem> menuItems;

  RestaurantMenu({@required this.restaurantId, @required this.menuItems})
      : assert(restaurantId != null),
        assert(menuItems != null);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Restaurant>(
        stream: Provider.of<FoodBloc>(context).getRestaurant(restaurantId),
        builder: (context, snapshot) {
          return DashboardFragment(
            title: (snapshot.hasData) ? snapshot.data.title : '-',
            child: Column(
              children: <Widget>[
                const SizedBox(height: 16),
                ..._buildItemGroups(menuItems),
              ],
            ),
          );
        });
  }

  List<Widget> _buildItemGroups(KtList<MenuItem> items) {
    var widgets = <Widget>[];
    groupBy<MenuItem, String>(items.asList(), (item) => item.counter)
        .forEach((counter, groupedItems) {
      widgets.addAll([
        MenuItemView(groupedItems.first),
        ...groupedItems
            .sublist(1)
            .map((i) => MenuItemView(i, showCounter: false))
      ]);
    });
    return widgets;
  }
}
