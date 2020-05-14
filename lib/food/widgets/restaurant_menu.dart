import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hpi_flutter/app/app.dart';
import 'package:hpi_flutter/core/core.dart';

import '../bloc.dart';
import '../data.dart';
import 'menu_item.dart';

class RestaurantMenu extends StatelessWidget {
  const RestaurantMenu(this.restaurantId) : assert(restaurantId != null);

  final String restaurantId;

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
      child: StreamBuilder<List<MenuItem>>(
          stream:
              services.get<FoodBloc>().getMenuItems(restaurantId: restaurantId),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return buildLoadingError(snapshot);
            }

            return Column(
              children: <Widget>[
                SizedBox(height: 16),
                ..._buildItemGroups(snapshot.data),
              ],
            );
          }),
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
