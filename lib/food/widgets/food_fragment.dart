import 'package:flutter/material.dart';
import 'package:flutter_cached/flutter_cached.dart';
import 'package:hpi_flutter/app/services/storage.dart';
import 'package:hpi_flutter/app/widgets/dashboard_page.dart';
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
    return ProxyProvider2<StorageService, Uri, FoodBloc>(
      builder: (_, storage, serverUrl, __) {
        print('Creating a food bloc.');
        return FoodBloc(storage, serverUrl, Localizations.localeOf(context));
      },
      child: Consumer<FoodBloc>(
        builder: (context, bloc, _) => _buildMenu(context, bloc),
      ),
    );
  }

  Widget _buildMenu(BuildContext context, FoodBloc bloc) {
    assert(context != null);
    assert(bloc != null);

    return CachedRawBuilder<KtList<MenuItem>>(
      controller: bloc.fetchMenuItems(),
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
              padding: EdgeInsets.all(16.0),
              child: Text(HpiL11n.get(context, 'food/noMenu')),
            ),
          );
        }

        var restaurantId = menuItems[0].restaurantId;
        return CachedRawBuilder<KtList<Restaurant>>(
          controller: bloc.fetchRestaurants(),
          builder: (context, update) {
            var restaurant = update.data.single((r) => r.id == restaurantId);
            return RestaurantMenu(
              restaurant: restaurant,
              menuItems: menuItems,
            );
          },
        );
      },
    );
  }
}
