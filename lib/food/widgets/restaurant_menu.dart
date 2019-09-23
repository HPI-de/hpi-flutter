import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hpi_flutter/app/widgets/hpi_theme.dart';
import 'package:kt_dart/kt.dart';
import 'package:provider/provider.dart';

import '../data/restaurant.dart';
import '../bloc.dart';
import 'menu_item.dart';

@immutable
class RestaurantMenu extends StatelessWidget {
  final String restaurantId;
  final KtList<MenuItem> menuItems;

  RestaurantMenu({@required this.restaurantId, @required this.menuItems})
      : assert(restaurantId != null),
        assert(menuItems != null);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Material(
          child: Padding(
            padding: EdgeInsets.only(top: 16, left: 16),
            child: Material(
              color: Colors.white,
              elevation: 4,
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 16),
                  ...menuItems.map((item) => MenuItemView(item)).iter,
                ],
              ),
            ),
          ),
        ),
        Material(
          color: HpiTheme.of(context).tertiary,
          child: StreamBuilder<Restaurant>(
            stream: Provider.of<FoodBloc>(context).getRestaurant(restaurantId),
            builder: (_, snapshot) {
              if (!snapshot.hasData)
                return Text(snapshot.hasError
                    ? snapshot.error.toString()
                    : 'Loading...');
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                child: Text(
                  snapshot.data?.title ?? '-',
                  style:
                      Theme.of(context).textTheme.title.copyWith(fontSize: 20),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
