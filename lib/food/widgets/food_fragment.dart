import 'package:flutter/material.dart';
import 'package:hpi_flutter/app/widgets/dashboard_page.dart';
import 'package:hpi_flutter/core/localizations.dart';
import 'package:hpi_flutter/food/bloc.dart';
import 'package:hpi_flutter/food/data/restaurant.dart';
import 'package:hpi_flutter/food/widgets/restaurant_menu.dart';
import 'package:kt_dart/kt.dart';
import 'package:provider/provider.dart';

@immutable
class FoodFragment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProxyProvider<Uri, FoodBloc>(
      builder: (_, serverUrl, __) => FoodBloc(serverUrl),
      child: Builder(
        builder: (context) => _buildMenu(context),
      ),
    );
  }

  Widget _buildMenu(BuildContext context) {
    return StreamBuilder<KtList<MenuItem>>(
      stream: Provider.of<FoodBloc>(context).getMenuItems(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(
            child: snapshot.hasError
                ? Text(snapshot.error.toString())
                : CircularProgressIndicator(),
          );

        var menuItems = snapshot.data;
        var restaurantId = snapshot.data[0].restaurantId;
        return RestaurantMenu(
          prefix: HpiL11n.get(context, 'food/fragment.title') + ' - ',
          restaurantId: restaurantId,
          menuItems:
              menuItems.filter((item) => item.restaurantId == restaurantId),
        );
      },
    );
  }
}
