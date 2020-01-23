import 'package:flutter_cached/flutter_cached.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hpi_flutter/app/services/storage.dart';
import 'package:hpi_flutter/app/widgets/app_bar.dart';
import 'package:hpi_flutter/app/widgets/utils.dart';
import 'package:hpi_flutter/core/localizations.dart';
import 'package:hpi_flutter/food/data/bloc.dart';
import 'package:kt_dart/collection.dart';
import 'package:provider/provider.dart';

import '../../app/widgets/main_scaffold.dart';
import '../data/restaurant.dart';
import 'restaurant_menu.dart';

@immutable
class FoodPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProxyProvider2<StorageService, Uri, FoodBloc>(
      builder: (_, storage, serverUrl, __) =>
          FoodBloc(storage, serverUrl, Localizations.localeOf(context)),
      child: MainScaffold(
        body: Consumer<FoodBloc>(
          builder: (context, bloc, _) => _buildRestaurantList(context, bloc),
        ),
      ),
    );
  }
}

Widget _buildRestaurantList(BuildContext context, FoodBloc bloc) {
  return CachedBuilder<KtList<Restaurant>>(
    controller: bloc.fetchRestaurants(),
    errorScreenBuilder: buildError,
    errorBannerBuilder: buildError,
    loadingScreenBuilder: (_) => Center(child: CircularProgressIndicator()),
    builder: (context, restaurants) {
      return CustomScrollView(
        slivers: <Widget>[
          HpiSliverAppBar(
            floating: true,
            title: Text(HpiL11n.get(context, 'food')),
          ),
          for (final restaurant in restaurants.iter)
            SliverToBoxAdapter(
              child: _buildMenuItemsOfRestaurant(context, bloc, restaurant),
            ),
        ],
      );
    },
  );
  /*return CachedBuilder<KtList<MenuItem>>(
    controller: Provider.of<FoodBloc>(context).fetchMenuItems(),
    errorScreenBuilder: buildError,
    errorBannerBuilder: buildError,
    hasScrollBody: false,
    builder: (context, items) {
      
    },
  );*/
}

Widget _buildMenuItemsOfRestaurant(
    BuildContext context, FoodBloc bloc, Restaurant restaurant) {
  return CachedRawBuilder<KtList<MenuItem>>(
    controller: bloc.fetchMenuItemsOfRestaurant(restaurant.id)..fetch(),
    builder: (context, update) {
      if (update.hasError) {
        buildError(context, update.error, update.stackTrace);
      }
      if (update.data.isEmpty()) {
        return Center(child: Text(HpiL11n.get(context, 'food/noMenu')));
      }

      return Padding(
        padding: const EdgeInsets.all(16),
        child: RestaurantMenu(
          restaurant: restaurant,
          menuItems: update.data,
        ),
      );
    },
  );
}
