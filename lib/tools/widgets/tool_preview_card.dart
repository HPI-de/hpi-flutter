import 'package:flutter/material.dart';

class ToolPreviewCard extends StatelessWidget {
  const ToolPreviewCard({
    Key key,
    @required this.icon,
    @required this.title,
    @required this.description,
  })  : assert(icon != null),
        assert(title != null),
        assert(description != null),
        super(key: key);

  final Widget icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: <Widget>[
            ConstrainedBox(
              constraints: BoxConstraints.tightFor(width: 96),
              child: icon,
            ),
            SizedBox(width: 8),
            Column(
              children: <Widget>[
                Text(
                  title,
                  style: Theme.of(context).textTheme.headline,
                ),
                Text(description),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
