import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grpc/grpc.dart';
import 'package:kt_dart/collection.dart';
import 'package:provider/provider.dart';

import '../data/restaurant.dart';
import '../bloc.dart';

class MenuItemView extends StatelessWidget {
  final MenuItem item;

  MenuItemView(this.item) : assert(item != null);

  void _showDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => MenuItemDetails(item),
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
                  if (item.substitution != null) ...[
                    SizedBox(height: 4),
                    Text(
                      'alternativ: ${item.substitution.title}',
                      style: Theme.of(context)
                          .textTheme
                          .body1
                          .copyWith(color: Colors.black54),
                    ),
                  ]
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

  MenuItemDetails(this.item) : assert(item != null);

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
                'Food ${item.counter}',
                style: Theme.of(context).textTheme.headline,
              ),
              Text(
                item.title,
                style: Theme.of(context).textTheme.subhead,
              ),
              Text(item.substitution.title ?? ''),
              // TODO: Add proper labels
              /*Wrap(
                children: item.labelIds
                    .map((id) => _buildChip(context, id))
                    .iter
                    .toList(),
              ),*/
            ],
          ),
        ),
        Text('${item.prices["student"].toStringAsFixed(2)} €'),
      ],
    );
  }

  Widget _buildChip(BuildContext context, String id) {
    return Chip(avatar: FlutterLogo(), label: Text(id));
    /*return StreamBuilder<Label>(
      stream: Provider.of<FoodBloc>(context).getLabel(id),
      builder: (_, snapshot) {
        if (!snapshot.hasData) return Container();
        var label = snapshot.data;
        return Chip(
          avatar: FlutterLogo(),
          label: Text(label.title),
        );
      }
    );*/
  }
}
