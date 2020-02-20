import 'package:align_positioned/align_positioned.dart';
import 'package:flutter/material.dart';
import 'package:hpi_flutter/food/food.dart';
import 'package:hpi_flutter/news/news.dart';
import 'package:hpi_flutter/openhpi/openhpi.dart';

import '../utils.dart';
import 'main_scaffold.dart';

@immutable
class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      body: ListView(
        padding:
            EdgeInsets.fromLTRB(16, context.mediaQuery.padding.top, 16, 32),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Align(
              alignment: Alignment.topRight,
              child: Image.asset(
                'assets/logo/logo_text.png',
                width: 200,
                height: 100,
                fit: BoxFit.contain,
              ),
            ),
          ),
          OpenHpiFragment(),
          NewsFragment(),
          FoodFragment(),
        ].expand((child) sync* {
          yield const SizedBox(height: 16);
          yield child;
        }).toList(),
      ),
    );
  }
}

@immutable
class DashboardFragment extends StatelessWidget {
  DashboardFragment({@required this.title, @required this.child})
      : assert(title != null),
        assert(child != null);

  final Widget title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 12, top: 16),
      child: Stack(
        children: <Widget>[
          Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: EdgeInsets.only(top: 16),
              child: child,
            ),
          ),
          Positioned.fill(
            child: AlignPositioned(
              alignment: Alignment.topLeft,
              dx: -12,
              moveByChildHeight: -0.5,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: context.hpiTheme.tertiary,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: DefaultTextStyle(
                    style: context.theme.textTheme.title,
                    child: title,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
