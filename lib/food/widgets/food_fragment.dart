import 'package:flutter/material.dart';
import 'package:flutter_cached/flutter_cached.dart';
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
      builder: (_, serverUrl, __) =>
          FoodBloc(serverUrl, Localizations.localeOf(context)),
      child: Builder(
        builder: (context) => _buildMenu(context),
      ),
    );
  }

  Widget _buildMenu(BuildContext context) {
    assert(context != null);

    return CachedRawBuilder<KtList<MenuItem>>(
      controller: Provider.of<FoodBloc>(context).menuItems,
      builder: (context, update) {
        if (update.hasError) {
          return Text('An error occurred: ${update.error}');
        }
        if (!update.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        final menuItems = update.data;
        if (menuItems.isEmpty()) {
          return DashboardFragment(
            title: Text(HpiL11n.get(context, 'food')),
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(16.0),
              child: Text(HpiL11n.get(context, 'food/noMenu')),
            ),
          );
        }

        var restaurantId = menuItems[0].restaurantId;
        return RestaurantMenu(
          restaurantId: restaurantId,
          menuItems: menuItems,
        );
      },
    );
  }
}
