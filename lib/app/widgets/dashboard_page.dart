import 'dart:io';

import 'package:align_positioned/align_positioned.dart';
import 'package:flutter/material.dart';
import 'package:hpi_flutter/core/localizations.dart';
import 'package:hpi_flutter/core/utils.dart';
import 'package:hpi_flutter/feedback/widgets/feedback_dialog.dart';
import 'package:hpi_flutter/food/widgets/food_fragment.dart';
import 'package:hpi_flutter/news/widgets/news_fragment.dart';

import 'package:hpi_flutter/openhpi/widgets/openhpi_fragment.dart';
import 'package:kt_dart/collection.dart';

import 'hpi_theme.dart';
import 'main_scaffold.dart';

@immutable
class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      bottomActions: KtList.from([
        PopupMenuButton(
          onSelected: (_) => FeedbackDialog.show(context),
          icon: Icon(Icons.more_vert),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'app.feedback',
              child: Text(HpiL11n.get(context, 'feedback/action')),
            ),
          ],
        ),
      ]),
      body: ListView(
        padding:
            EdgeInsets.fromLTRB(16, MediaQuery.of(context).padding.top, 16, 32),
        children: <Widget>[
          FlatButton(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              alignment: Alignment.topRight,
              child: LimitedBox(
                maxWidth: 200,
                maxHeight: 100,
                child: Image.asset('assets/logo/logo_text.png'),
              ),
            ),
            onPressed: () => tryLaunch('https://hpi.de'),
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
                  color: HpiTheme.of(context).tertiary,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: DefaultTextStyle(
                    style: Theme.of(context).textTheme.title,
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
