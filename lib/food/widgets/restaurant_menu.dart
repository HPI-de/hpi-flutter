import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hpi_flutter/app/app.dart';
import 'package:hpi_flutter/core/core.dart';

import '../bloc.dart';
import '../data.dart';
import 'menu_item.dart';

class RestaurantMenu extends StatelessWidget {
  const RestaurantMenu({@required this.restaurantId, @required this.menuItems})
      : assert(restaurantId != null),
        assert(menuItems != null);

  final String restaurantId;
  final List<MenuItem> menuItems;

  @override
  Widget build(BuildContext context) {
    final s = context.s;

    return DashboardFragment(
      title: StreamBuilder<Restaurant>(
        stream: services.get<FoodBloc>().getRestaurant(restaurantId),
        builder: (context, snapshot) => Text(
          snapshot.hasData ? snapshot.data.title : s.general_loading,
        ),
      ),
      child: Column(
        children: <Widget>[
          const SizedBox(height: 16),
          ..._buildItemGroups(menuItems),
        ],
      ),
    );
  }

  Iterable<Widget> _buildItemGroups(List<MenuItem> items) {
    assert(items != null);

    final itemsPerCounter = items.groupBy((i) => i.counter).values;
    return itemsPerCounter.flatMap((e) {
      return e.mapIndexed(
          (index, item) => MenuItemView(item, showCounter: index == 0));
    });
  }
}
