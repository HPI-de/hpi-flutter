import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hpi_flutter/app/widgets/dashboard_page.dart';
import 'package:hpi_flutter/core/localizations.dart';
import 'package:hpi_flutter/food/data/bloc.dart';
import 'package:kt_dart/kt.dart';
import 'package:provider/provider.dart';

import '../data/restaurant.dart';
import 'menu_item.dart';

@immutable
class RestaurantMenu extends StatelessWidget {
  final Restaurant restaurant;
  final KtList<MenuItem> menuItems;

  RestaurantMenu({@required this.restaurant, @required this.menuItems})
      : assert(restaurant != null),
        assert(menuItems != null);

  @override
  Widget build(BuildContext context) {
    return DashboardFragment(
      title: Text(restaurant?.title ?? HpiL11n.get(context, 'loading')),
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
