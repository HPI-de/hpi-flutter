import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hpi_flutter/app/app.dart';
import 'package:hpi_flutter/core/core.dart';
import 'package:kt_dart/kt.dart';

import '../bloc.dart';
import '../data.dart';
import 'menu_item.dart';

class RestaurantMenu extends StatelessWidget {
  const RestaurantMenu({@required this.restaurantId, @required this.menuItems})
      : assert(restaurantId != null),
        assert(menuItems != null);

  final String restaurantId;
  final KtList<MenuItem> menuItems;

  @override
  Widget build(BuildContext context) {
    return DashboardFragment(
      title: StreamBuilder<Restaurant>(
        stream: services.get<FoodBloc>().getRestaurant(restaurantId),
        builder: (context, snapshot) => Text(
          snapshot.hasData
              ? snapshot.data.title
              : HpiL11n.get(context, 'loading'),
        ),
      ),
      child: Column(
        children: <Widget>[
          const SizedBox(height: 16),
          ..._buildItemGroups(menuItems).iter,
        ],
      ),
    );
  }

  KtList<Widget> _buildItemGroups(KtList<MenuItem> items) {
    assert(items != null);

    return items.groupBy((i) => i.counter).toList().flatMap(
          (e) =>
              KtList.of(MenuItemView(e.second.first())) +
              e.second.drop(1).map((i) => MenuItemView(i, showCounter: false)),
        );
  }
}
