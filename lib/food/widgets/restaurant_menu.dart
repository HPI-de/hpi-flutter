import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hpi_flutter/app/app.dart';
import 'package:hpi_flutter/app/widgets/dashboard_page.dart';
import 'package:hpi_flutter/core/localizations.dart';
import 'package:hpi_flutter/food/data/bloc.dart';
import 'package:kt_dart/kt.dart';

import '../data/restaurant.dart';
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
