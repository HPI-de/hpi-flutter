import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hpi_flutter/core/localizations.dart';
import 'package:kt_dart/collection.dart';
import 'package:provider/provider.dart';

import '../data/restaurant.dart';
import '../bloc.dart';

class MenuItemView extends StatelessWidget {
  final MenuItem item;

  MenuItemView(this.item) : assert(item != null);

  void _showDetails(BuildContext context) {
    var _foodBloc = Provider.of<FoodBloc>(context);
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
                item.counter,
                style:
                    Theme.of(context).textTheme.caption.copyWith(fontSize: 20),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(item.title, style: Theme.of(context).textTheme.body1),
                ],
              ),
            ),
            SizedBox(width: 8),
            _buildLabels(item.labelIds),
          ],
        ),
      ),
    );
  }

  Widget _buildLabels(KtSet<String> labelIds) {
    var ids = labelIds.asIterable().toList();
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
      color: Color.lerp(Colors.white, Colors.black, 0.1),
      elevation: 2,
      shape: CircleBorder(),
      child: StreamBuilder<Label>(
        stream: Provider.of<FoodBloc>(context).getLabel(labelId),
        builder: (_, snapshot) {
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

  MenuItemDetails(this.item, this.foodBloc) : assert(item != null);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.8,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                '${HpiL11n.get(context, "food/offer")} ${item.counter}',
                style: Theme.of(context).textTheme.headline,
              ),
              Text(
                item.title,
                style: Theme.of(context).textTheme.subhead,
              ),
              Wrap(
                spacing: 8,
                children: item.labelIds
                    .map((id) => _buildChip(context, id))
                    .iter
                    .toList(),
              ),
            ],
          ),
        ),
        Text('${item.prices["students"].toStringAsFixed(2)} €'),
      ],
    );
  }

  Widget _buildChip(BuildContext context, String id) {
    return StreamBuilder<Label>(
        stream: foodBloc.getLabel(id),
        builder: (_, snapshot) {
          if (!snapshot.hasData)
            return Chip(
              avatar: Icon(Icons.restaurant),
              label: Text(id),
            );
          var label = snapshot.data;
          return Chip(
            avatar: (label.icon.isNotEmpty)
                ? Image.network(label.icon)
                : Icon(Icons.restaurant),
            label: Text(label.title),
          );
        });
  }
}
