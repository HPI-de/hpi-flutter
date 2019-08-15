import 'package:align_positioned/align_positioned.dart';
import 'package:flutter/material.dart';

import 'package:hpi_flutter/openhpi/widgets/openhpi_fragment.dart';

import 'hpi_theme.dart';

@immutable
class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.all(16),
        children: <Widget>[
          OpenHpiFragment(),
        ]
            .expand((child) sync* {
              yield const SizedBox(height: 16);
              yield child;
            })
            .skip(1)
            .toList(),
      ),
    );
  }
}

@immutable
class DashboardFragment extends StatelessWidget {
  DashboardFragment({@required this.title, @required this.child})
      : assert(title != null),
        assert(child != null);

  final String title;
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
              padding: EdgeInsets.only(top:16),
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
                  color: HpiTheme.of(context).tertiary,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.title,
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
