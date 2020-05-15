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

  Widget _buildRestaurantList(BuildContext context) {
    final s = context.s;

    return StreamBuilder<List<Restaurant>>(
      stream: services.get<FoodBloc>().getRestaurants(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return buildLoadingErrorSliver(snapshot);
        }

        final restaurants = snapshot.data;
        if (restaurants.isEmpty) {
          return SliverFillRemaining(
            child: Center(child: Text(s.food_noMenu)),
          );
        }

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return Padding(
                padding: EdgeInsets.all(16),
                child: RestaurantMenu(restaurants[index].id),
              );
            },
            childCount: restaurants.length,
          ),
        );
      },
    );
  }
}
