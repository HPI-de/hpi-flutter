import 'package:flutter/material.dart' hide Action;
import 'package:flutter_html/flutter_html.dart';
import 'package:hpi_flutter/myhpi/data/bloc.dart';
import 'package:hpi_flutter/myhpi/data/infobit.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoBitCard extends StatelessWidget {
  const InfoBitCard(this.infoBit, {Key key})
      : assert(infoBit != null),
        super(key: key);

  final InfoBit infoBit;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              infoBit.title,
              style: Theme.of(context).textTheme.headline,
            ),
            SizedBox(height: 4),
            Text(
              infoBit.description,
              style: Theme.of(context)
                  .textTheme
                  .body1
                  .copyWith(color: Colors.black.withOpacity(0.6)),
            ),
            Wrap(
              alignment: WrapAlignment.start,
              spacing: 8,
              runSpacing: 8,
              children: infoBit.actionIds
                  .map((a) => StreamBuilder<Action>(
                        stream: Provider.of<MyHpiBloc>(context).getAction(a),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) return null;
                          if (!snapshot.hasData)
                            return Chip(label: Text('Loading...'));
                          return _buildActionChip(context, snapshot.data);
                        },
                      ))
                  .asList(),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildActionChip(BuildContext context, Action action) {
    assert(action != null);

    return ActionChip(
      label: Text(action.title),
      onPressed: () async {
        if (action is ActionText)
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Scaffold(
                appBar: AppBar(title: Text(action.title)),
                body: Html(
                  data: action.content,
                ),
              ),
            ),
          );
        else if (action is ActionLink && await canLaunch(action.url))
          await launch(action.url);
      },
    );
  }
}
