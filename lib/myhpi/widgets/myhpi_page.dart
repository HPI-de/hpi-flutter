import 'package:flutter/material.dart';
import 'package:grpc/grpc.dart';
import 'package:hpi_flutter/myhpi/data/infobit.dart';
import 'package:hpi_flutter/myhpi/widgets/infobit_card.dart';
import 'package:kt_dart/collection.dart';
import 'package:provider/provider.dart';

import '../data/bloc.dart';

class MyHpiPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProxyProvider<ClientChannel, MyHpiBloc>(
      builder: (_, channel, __) => MyHpiBloc(channel),
      child: Scaffold(
        appBar: AppBar(
          title: Text('MyHPI'),
        ),
        body: InfoBitList(),
      ),
    );
  }
}

class InfoBitList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<KtList<InfoBit>>(
      stream: Provider.of<MyHpiBloc>(context).getInfoBits(),
      builder: (context, snapshot) {
        if (snapshot.hasError)
          return Center(child: Text(snapshot.error.toString()));
        if (!snapshot.hasData) return Placeholder();

        return ListView(
          children: snapshot.data
              .map((i) => InfoBitCard(
                    infoBit: i,
                  ))
              .asList(),
        );
      },
    );
  }
}
