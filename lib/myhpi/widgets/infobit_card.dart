import 'package:flutter/material.dart';
import 'package:grpc/grpc.dart';
import 'package:hpi_flutter/myhpi/bloc.dart';
import 'package:hpi_flutter/myhpi/data/infobit.dart';
import 'package:hpi_flutter/myhpi/data/infobit.dart' as prefix0;
import 'package:provider/provider.dart';

class InfoBitCard extends StatelessWidget {
  final InfoBit infoBit;

  const InfoBitCard({Key key, this.infoBit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Text(
            infoBit.title,
            style: Theme.of(context).textTheme.subhead,
          ),
          Text(infoBit.description),
          Wrap(
            children: infoBit.actionIds
                .map((a) => StreamBuilder<prefix0.Action>(
                      stream: MyHPIBloc(Provider.of<ClientChannel>(context))
                          .getAction(a),
                      builder: (context, snapshot) {
                        return ActionChip(
                          label: Text(snapshot.data.title),
                          onPressed: () {},
                        );
                      },
                    ))
                .asList(),
          )
        ],
      ),
    );
  }
}
