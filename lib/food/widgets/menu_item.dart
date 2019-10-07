import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hpi_flutter/core/localizations.dart';
import 'package:hpi_flutter/food/data/bloc.dart';
import 'package:kt_dart/collection.dart';
import 'package:provider/provider.dart';

import '../data/restaurant.dart';

class MenuItemView extends StatelessWidget {
  final MenuItem item;
  final bool showCounter;

  MenuItemView(
    this.item, {
    this.showCounter = true,
  })  : assert(item != null),
        assert(showCounter != null);

  void _showDetails(BuildContext context) {
    final _foodBloc = Provider.of<FoodBloc>(context);
    showModalBottomSheet(
      context: context,
      builder: (context) => MenuItemDetails(item, _foodBloc),
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
                showCounter ? item.counter : ' ',
                style:
                    Theme.of(context).textTheme.caption.copyWith(fontSize: 20),
              ),
            ),
            Expanded(
              child: Text(item.title, style: Theme.of(context).textTheme.body1),
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

  Widget _buildLabels(KtSet<String> labelIds) {
    final ids = labelIds.toList();
    if (ids.isEmpty()) return Container();

    return Stack(
      children: [
        for (int i = 0; i < ids.size; i++)
          Padding(
            padding: EdgeInsets.only(left: (ids.size - i) * 16.0),
            child: LabelView(ids[i]),
          ),
      ],
    );
  }
}

class LabelView extends StatelessWidget {
  final String labelId;

  LabelView(this.labelId) : assert(labelId != null);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.circle,
      color: Color.lerp(Colors.white, Colors.black, 0.05),
      elevation: 1,
      child: StreamBuilder<Label>(
        stream: Provider.of<FoodBloc>(context).getLabel(labelId),
        builder: (_, snapshot) {
          if (!snapshot.hasData) return Container();

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
  final MenuItem item;
  final FoodBloc foodBloc;

  MenuItemDetails(this.item, this.foodBloc)
      : assert(item != null),
        assert(foodBloc != null);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.8,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                HpiL11n.get(context, "food/offer", args: [item.counter]),
                style: Theme.of(context).textTheme.headline,
              ),
              Text(
                item.title,
                style: Theme.of(context).textTheme.subhead,
              ),
              Wrap(
                spacing: 8,
                children:
                    item.labelIds.map((id) => _buildChip(context, id)).asList(),
              ),
            ],
          ),
        ),
        Text(
          HpiL11n.get(context, 'currency.eur', args: [item.prices["students"]]),
        ),
      ],
    );
  }

  Widget _buildChip(BuildContext context, String id) {
    assert(context != null);
    assert(id != null);

    return StreamBuilder<Label>(
        stream: foodBloc.getLabel(id),
        builder: (_, snapshot) {
          if (!snapshot.hasData) return Chip(label: Text(id));

          final label = snapshot.data;
          return Chip(label: Text(label.title));
        });
  }
}
