import 'package:cached_listview/cached_listview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hpi_flutter/app/widgets/app_bar.dart';
import 'package:hpi_flutter/core/localizations.dart';
import 'package:kt_dart/collection.dart';
import 'package:provider/provider.dart';

import '../../app/widgets/main_scaffold.dart';
import '../bloc.dart';
import '../data/restaurant.dart';
import 'restaurant_menu.dart';

@immutable
class FoodPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: use the actual grpc client channel as below
    return ProxyProvider<Uri, FoodBloc>(
      builder: (_, serverUrl, __) => FoodBloc(serverUrl),
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
  return CachedCustomScrollView<MenuItem>(
    controller: Provider.of<FoodBloc>(context).menuItems,
    sliverBuilder: (context, update) {
      assert(update.hasData || update.hasError);

      if (update.hasError && !update.hasData) {
        return [
          SliverFillRemaining(
            child: Center(child: Text('${update.error}')),
          )
        ];
      }

      return [
        if (update.hasError)
          SliverList(
            delegate: SliverChildListDelegate([
              Material(
                elevation: 8,
                child: Text("You're currently viewing cached offline data."),
              ),
            ]),
          ),
        if (update.hasData)
          _buildMenuSlivers(context, KtList.from(update.data)),
      ];
    },
  );
  return StreamBuilder<KtList<MenuItem>>(
    stream: Provider.of<FoodBloc>(context).getMenuItems(),
    builder: (context, snapshot) {
      if (!snapshot.hasData)
        return SliverFillRemaining(
          child: Center(
            child: snapshot.hasError
                ? Text(snapshot.error)
                : CircularProgressIndicator(),
          ),
        );
      if (!snapshot.hasData) return Placeholder();

      var menuItems = snapshot.data;
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
