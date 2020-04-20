import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hpi_flutter/app/app.dart';
import 'package:hpi_flutter/core/core.dart';

import '../bloc.dart';
import '../data.dart';
import 'restaurant_menu.dart';

class FoodPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          HpiSliverAppBar(
            floating: true,
            title: Text(context.s.food),
          ),
          Builder(
            builder: _buildRestaurantList,
          ),
        ],
      ),
    );
  }
}

Widget _buildRestaurantList(BuildContext context) {
  final s = context.s;

  return StreamBuilder<List<MenuItem>>(
    stream: services.get<FoodBloc>().getMenuItems(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return buildLoadingErrorSliver(snapshot);
      }

      if (snapshot.data.isEmpty) {
        return SliverFillRemaining(
          child: Center(child: Text(s.food_noMenu)),
        );
      }

      var menuItems = snapshot.data;
      var allRestaurants =
          menuItems.map((item) => item.restaurantId).toSet().toList();
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => Padding(
            padding: const EdgeInsets.all(16),
            child: RestaurantMenu(
              restaurantId: allRestaurants[index],
              menuItems: menuItems
                  .where((item) => item.restaurantId == allRestaurants[index]),
            ),
          ),
          childCount: allRestaurants.length,
        ),
      );
    },
  );
}
