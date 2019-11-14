import 'package:flutter_cached/flutter_cached.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
    return ProxyProvider<Uri, FoodBloc>(
      builder: (_, serverUrl, __) =>
          FoodBloc(serverUrl, Localizations.localeOf(context)),
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
    controller: Provider.of<FoodBloc>(context).menuItems,
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
  return SliverList(
    delegate: SliverChildBuilderDelegate(
      (context, index) => Padding(
        padding: const EdgeInsets.all(16),
        child: RestaurantMenu(
          restaurantId: allRestaurants[index],
          menuItems: items
              .filter((item) => item.restaurantId == allRestaurants[index]),
        ),
      ),
      childCount: allRestaurants.size,
    ),
  );
}
