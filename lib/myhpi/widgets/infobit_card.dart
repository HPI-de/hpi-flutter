import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:grpc/grpc.dart';
import 'package:hpi_flutter/myhpi/data/bloc.dart';
import 'package:hpi_flutter/myhpi/data/infobit.dart';
import 'package:hpi_flutter/myhpi/data/infobit.dart' as prefix0;
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoBitCard extends StatelessWidget {
  final InfoBit infoBit;

  const InfoBitCard({Key key, this.infoBit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              infoBit.title,
              style: Theme.of(context).textTheme.headline,
            ),
            SizedBox(height: 8.0),
            Text(
              infoBit.description,
              style: Theme.of(context).textTheme.subhead,
            ),
            Wrap(
              alignment: WrapAlignment.start,
              spacing: 8.0,
              children: infoBit.actionIds
                  .map((a) => StreamBuilder<prefix0.Action>(
                        stream: MyHpiBloc(Provider.of<ClientChannel>(context))
                            .getAction(a),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData)
                            return Chip(label: Text('Loading...'));
                          return ActionChip(
                            label: Text(snapshot.data.title),
                            onPressed: () async {
                              if (snapshot.data is ActionText) {
                                var content =
                                    (snapshot.data as ActionText).content;
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return Scaffold(
                                    appBar: AppBar(
                                        title: Text(snapshot.data.title)),
                                    body: Html(
                                      data: content,
                                    ),
                                  );
                                }));
                              } else if (snapshot.data is ActionLink) {
                                var url = (snapshot.data as ActionLink).url;
                                if (await canLaunch(url)) await launch(url);
                              }
                            },
                          );
                        },
                      ))
                  .asList(),
            )
          ],
        ),
      ),
    );
  }
}
