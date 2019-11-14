import 'package:flutter/material.dart' hide Route;
import 'package:hpi_flutter/app/services/navigation.dart';
import 'package:hpi_flutter/core/hpi_icons.dart';
import 'package:hpi_flutter/core/localizations.dart';
import 'package:hpi_flutter/route.dart';
import 'package:kt_dart/collection.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:provider/provider.dart';

@immutable
class MainScaffold extends StatelessWidget {
  final PreferredSizeWidget appBar;
  final Widget body;
  final Widget floatingActionButton;
  final KtList<Widget> bottomActions;

  MainScaffold({
    this.appBar,
    @required this.body,
    this.floatingActionButton,
    KtList<Widget> bottomActions,
  })  : assert(body != null),
        this.bottomActions = bottomActions ?? KtList.empty();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: body,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(OMIcons.menu),
              onPressed: () {
                _openNavDrawer(context);
              },
            ),
            Spacer(),
            ...bottomActions.iter,
          ],
        ),
      ),
    );
  }

  void _openNavDrawer(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => ListView(
        shrinkWrap: true,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: <Widget>[
                SizedBox(width: 16),
                Image.asset('assets/logo/logo_text.png', height: 56),
                Spacer(),
                IconButton(
                  icon: Icon(OMIcons.settings),
                  iconSize: 32,
                  padding: EdgeInsets.all(8),
                  onPressed: () {
                    Navigator.popAndPushNamed(context, Route.settings.name);
                  },
                ),
              ],
            ),
          ),
          Divider(indent: 8, endIndent: 8),
          NavigationItem(
            icon: OMIcons.home,
            text: HpiL11n.get(context, 'dashboard'),
            route: Route.dashboard,
          ),
          NavigationItem(
            icon: OMIcons.school,
            text: HpiL11n.get(context, 'course'),
            route: Route.courses,
          ),
          NavigationItem(
            icon: OMIcons.restaurantMenu,
            text: HpiL11n.get(context, 'food'),
            route: Route.food,
          ),
          NavigationItem(
            icon: HpiIcons.myhpi,
            text: HpiL11n.get(context, 'myhpi'),
            route: Route.myhpi,
          ),
          NavigationItem(
            icon: HpiIcons.newspaper,
            text: HpiL11n.get(context, 'news'),
            route: Route.news,
          ),
          NavigationItem(
            icon: HpiIcons.tools,
            text: HpiL11n.get(context, 'tools'),
            route: Route.tools,
          ),
          SizedBox(height: 12),
        ],
      ),
    );
  }
}

@immutable
class NavigationItem extends StatelessWidget {
  const NavigationItem({
    @required this.icon,
    @required this.text,
    @required this.route,
  })  : assert(icon != null),
        assert(text != null),
        assert(route != null);

  final IconData icon;
  final String text;
  final Route route;

  @override
  Widget build(BuildContext context) {
    var isActive =
        route == Provider.of<NavigationService>(context).lastKnownRoute;
    var color = isActive
        ? Theme.of(context).primaryColor
        : Theme.of(context).colorScheme.onSurface.withOpacity(0.87);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Material(
        borderRadius: BorderRadius.circular(4),
        color: isActive ? color.withOpacity(0.2) : Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(4),
          onTap: () {
            var navigator = Navigator.of(context);
            var lastKnownRoute =
                Provider.of<NavigationService>(context).lastKnownRoute;
            if (lastKnownRoute.name != route.name) {
              navigator
                ..popUntil((_) => !navigator.canPop())
                ..pushNamed(route.name);
            } else {
              navigator.pop();
            }
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: <Widget>[
                Icon(
                  icon,
                  color: color,
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    text,
                    style: Theme.of(context)
                        .textTheme
                        .body2
                        .copyWith(color: color),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
