import 'package:flutter/material.dart';
import 'package:hpi_flutter/app/widgets/dashboard_page.dart';
import 'package:hpi_flutter/app/widgets/utils.dart';
import 'package:hpi_flutter/core/localizations.dart';
import 'package:hpi_flutter/food/data/bloc.dart';
import 'package:hpi_flutter/food/data/restaurant.dart';
import 'package:hpi_flutter/food/widgets/restaurant_menu.dart';
import 'package:kt_dart/kt.dart';
import 'package:provider/provider.dart';

@immutable
class FoodFragment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProxyProvider<Uri, FoodBloc>(
      builder: (_, serverUrl, __) => FoodBloc(serverUrl),
      child: Builder(
        builder: (context) => _buildMenu(context),
      ),
    );
  }

  Widget _buildMenu(BuildContext context) {
    assert(context != null);

    return StreamBuilder<KtList<MenuItem>>(
      stream: Provider.of<FoodBloc>(context)
          .getMenuItems(restaurantId: 'mensaGriebnitzsee'),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return buildLoadingError(snapshot);

        if (snapshot.data.isEmpty()) {
          return DashboardFragment(
            title: Text(HpiL11n.get(context, 'food')),
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(16.0),
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
