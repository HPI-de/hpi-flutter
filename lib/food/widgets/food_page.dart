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
        body: CustomScrollView(
          slivers: <Widget>[
            HpiSliverAppBar(
              floating: true,
              title: Text(HpiL11n.get(context, 'food')),
            ),
            Builder(builder: (context) => _buildRestaurantList(context)),
          ],
        ),
      ),
    );
  }
}

Widget _buildRestaurantList(BuildContext context) {
  return CachedBuilder<KtList<MenuItem>>(
    controller: Provider.of<FoodBloc>(context).fetchMenuItems(),
    errorScreenBuilder: buildError,
    errorBannerBuilder: buildError,
    hasScrollBody: true,
    builder: (context, items) {
      if (items.isEmpty()) {
        return Center(child: Text(HpiL11n.get(context, 'food/noMenu')));
      } else {
        return _buildMenuSlivers(context, items);
      }
    },
  );
}

Widget _buildMenuSlivers(BuildContext context, KtList<MenuItem> items) {
  var allRestaurants = items.map((item) => item.restaurantId).toSet().toList();
  var restaurants = Provider.of<FoodBloc>(context).fetchRestaurants();

  return CachedRawBuilder(
    controller: restaurants,
    builder: (context, update) {
      if (!update.hasData) {
        return Container();
      }
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => Padding(
            padding: const EdgeInsets.all(16),
            child: RestaurantMenu(
              restaurant: update.data[index],
              menuItems: items
                  .filter((item) => item.restaurantId == allRestaurants[index]),
            ),
          ),
          childCount: allRestaurants.size,
        ),
      );
    },
  );
}
