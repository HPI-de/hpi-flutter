import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grpc/grpc.dart';
import 'package:kt_dart/collection.dart';
import 'package:provider/provider.dart';

import '../bloc.dart';
import '../data/restaurant.dart';
import 'restaurant_menu.dart';

@immutable
class FoodPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: use the actual grpc client channel as below
    return Provider<FoodBloc>(
      builder: (_) => FoodBloc(null),
      child: Scaffold(
        appBar: AppBar(title: Text("Food")),
        body: RestaurantList(),
      ),
    );
    /*return ProxyProvider<ClientChannel, FoodBloc>(
      builder: (_, channel, __) => FoodBloc(channel),
      child: Scaffold(
        appBar: AppBar(title: Text("Food")),
        body: RestaurantList(),
      ),
    );*/
  }
}

class RestaurantList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<KtList<MenuItem>>(
      stream: Provider.of<FoodBloc>(context).getMenuItems(),
      builder: (context, snapshot) {
        if (snapshot.hasError)
          return Center(
            child: Text(snapshot.error),
          );
        if (!snapshot.hasData) return Placeholder();

        var menuItems = snapshot.data;
        var allRestaurants = menuItems.map((item) => item.restaurantId).toSet();
        return ListView(children: [
          const SizedBox(height: 16),
          for (var id in allRestaurants.iter) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: RestaurantMenu(
                restaurantId: id,
                menuItems: menuItems.filter((item) => item.restaurantId == id),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ]);
      },
    );
  }
}
