import 'package:flutter/material.dart';
import 'package:hpi_flutter/app/widgets/main_scaffold.dart';
import 'package:hpi_flutter/myhpi/data/bloc.dart';
import 'package:hpi_flutter/myhpi/data/infobit.dart';
import 'package:kt_dart/collection.dart';
import 'package:provider/provider.dart';

import 'infobit_card.dart';

class MyHpiPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProxyProvider<Uri, MyHpiBloc>(
      builder: (_, serverUrl, __) => MyHpiBloc(serverUrl),
      child: MainScaffold(
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
          children: snapshot.data.map((i) => InfoBitCard(i)).asList(),
        );
      },
    );
  }
}
