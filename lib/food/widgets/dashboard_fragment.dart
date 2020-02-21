import 'package:flutter/material.dart';
import 'package:hpi_flutter/app/app.dart';
import 'package:hpi_flutter/core/core.dart';
import 'package:kt_dart/kt.dart';

import '../bloc.dart';
import '../data.dart';
import 'restaurant_menu.dart';

class FoodFragment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<KtList<MenuItem>>(
      stream: services
          .get<FoodBloc>()
          .getMenuItems(restaurantId: 'mensaGriebnitzsee'),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return buildLoadingError(snapshot);
        }

        if (snapshot.data.isEmpty()) {
          return DashboardFragment(
            title: Text(HpiL11n.get(context, 'food')),
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(16),
              child: Text(HpiL11n.get(context, 'food/noMenu')),
            ),
          );
        }

        var menuItems = snapshot.data;
        var restaurantId = snapshot.data[0].restaurantId;
        return RestaurantMenu(
          restaurantId: restaurantId,
          menuItems: menuItems,
        );
      },
    );
  }
}
