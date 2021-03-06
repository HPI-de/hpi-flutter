import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hpi_flutter/app/app.dart';
import 'package:hpi_flutter/core/core.dart';

import '../bloc.dart';
import '../data.dart';

class MenuItemView extends StatelessWidget {
  const MenuItemView(
    this.item, {
    this.showCounter = true,
  })  : assert(item != null),
        assert(showCounter != null);

  final MenuItem item;
  final bool showCounter;

  void _showDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => MenuItemDetails(item),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showDetails(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 32,
              child: Text(
                showCounter ? item.counter.chars.first : ' ',
                style: context.textTheme.caption.copyWith(fontSize: 20),
              ),
            ),
            Expanded(
              child: Text(item.title, style: context.textTheme.bodyText2),
            ),
            SizedBox(width: 8),
            // Currently, label icons aren't sent by the server.
            // Once they are, this code will be added back.
            // _buildLabels(item.labelIds),
          ],
        ),
      ),
    );
  }

  // ignore: unused_element
  Widget _buildLabels(Set<String> labelIds) {
    final ids = labelIds.toList();
    if (ids.isEmpty) {
      return Container();
    }

    return Stack(
      children: [
        for (int i = 0; i < ids.length; i++)
          Padding(
            padding: EdgeInsets.only(left: (ids.length - i) * 16.0),
            child: LabelView(ids[i]),
          ),
      ],
    );
  }
}

class LabelView extends StatelessWidget {
  const LabelView(this.labelId) : assert(labelId != null);

  final String labelId;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.circle,
      color: Color.lerp(Colors.white, Colors.black, 0.05),
      elevation: 1,
      child: StreamBuilder<Label>(
        stream: services.get<FoodBloc>().getLabel(labelId),
        builder: (_, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }

          return Padding(
            padding: const EdgeInsets.all(4),
            child: snapshot.hasData
                ? Icon(Icons.restaurant, semanticLabel: snapshot.data.title)
                : Container(),
          );
        },
      ),
    );
  }
}

class MenuItemDetails extends StatelessWidget {
  const MenuItemDetails(this.item) : assert(item != null);

  final MenuItem item;

  @override
  Widget build(BuildContext context) {
    final s = context.s;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: <Widget>[
        Container(
          width: context.mediaQuery.size.width * 0.8,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                s.food_offer(item.counter),
                style: context.textTheme.headline5,
              ),
              Text(
                item.title,
                style: context.textTheme.subtitle1,
              ),
              ChipGroup(
                children: [
                  for (final labelId in item.labelIds)
                    _buildChip(context, labelId),
                ],
              ),
            ],
          ),
        ),
        Text(s.general_currency(
          'eur',
          item.prices['students'].toStringAsFixed(2),
        )),
      ],
    );
  }

  Widget _buildChip(BuildContext context, String id) {
    assert(context != null);
    assert(id != null);

    return StreamBuilder<Label>(
      stream: services.get<FoodBloc>().getLabel(id),
      builder: (_, snapshot) {
        if (!snapshot.hasData) {
          return Chip(label: Text(id));
        }

        final label = snapshot.data;
        return Chip(
          label: Text(label.title),
        );
      },
    );
  }
}
