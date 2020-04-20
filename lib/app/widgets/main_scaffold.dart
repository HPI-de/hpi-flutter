import 'package:flutter/material.dart' hide Route;
import 'package:hpi_flutter/app/app.dart';
import 'package:hpi_flutter/core/core.dart' hide Image;
import 'package:hpi_flutter/feedback/feedback.dart';
import 'package:outline_material_icons/outline_material_icons.dart';

import '../utils.dart';

class MainScaffold extends StatelessWidget {
  const MainScaffold({
    this.appBar,
    @required this.body,
    this.floatingActionButton,
    this.bottomActions = const [],
    this.menuItems,
    this.menuItemHandler,
  })  : assert(body != null),
        assert(bottomActions != null);

  final PreferredSizeWidget appBar;
  final Widget body;
  final Widget floatingActionButton;
  final List<Widget> bottomActions;
  final List<PopupMenuItem> menuItems;
  final Function(dynamic) menuItemHandler;

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
            ...bottomActions,
            PopupMenuButton(
              onSelected: (selected) {
                if (selected == 'app.feedback') {
                  FeedbackDialog.show(context);
                } else {
                  menuItemHandler(selected);
                }
              },
              icon: Icon(Icons.more_vert),
              itemBuilder: (context) => [
                if (menuItems != null) ...menuItems,
                PopupMenuItem(
                  value: 'app.feedback',
                  child: Text(context.s.feedback_action),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  void _openNavDrawer(BuildContext context) {
    final s = context.s;

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
                    Navigator.popAndPushNamed(context, '/settings');
                  },
                ),
              ],
            ),
          ),
          Divider(indent: 8, endIndent: 8),
          NavigationItem(
            icon: OMIcons.home,
            text: s.dashboard,
            route: '/dashboard',
          ),
          NavigationItem(
            icon: OMIcons.school,
            text: s.course,
            route: '/courses',
          ),
          NavigationItem(
            icon: OMIcons.restaurantMenu,
            text: s.food,
            route: '/food',
          ),
          NavigationItem(
            icon: HpiIcons.myhpi,
            text: s.myhpi,
            route: '/myhpi',
          ),
          NavigationItem(
            icon: HpiIcons.newspaper,
            text: s.news,
            route: '/news',
          ),
          NavigationItem(
            icon: HpiIcons.tools,
            text: s.tools,
            route: '/tools/timer',
          ),
          SizedBox(height: 12),
        ],
      ),
    );
  }
}

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
  final String route;

  @override
  Widget build(BuildContext context) {
    var isActive = route == services.get<NavigationService>().lastKnownRoute;
    var color = isActive
        ? context.theme.primaryColor
        : context.theme.colorScheme.onSurface.withOpacity(0.6);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Material(
        borderRadius: BorderRadius.circular(4),
        color: isActive ? color.withOpacity(0.2) : Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(4),
          onTap: () => context.navigator.pushNamed(route),
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
                    style: context.textTheme.body2.copyWith(color: color),
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
