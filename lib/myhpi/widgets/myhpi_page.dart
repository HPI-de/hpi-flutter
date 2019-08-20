import 'package:flutter/material.dart';
import 'package:hpi_flutter/app/widgets/main_scaffold.dart';
import 'package:hpi_flutter/app/widgets/utils.dart';
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
        body: CustomScrollView(slivers: <Widget>[
          SliverAppBar(title: Text('MyHPI')),
          InfoBitList(),
        ]),
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
        if (!snapshot.hasData) return buildLoadingErrorSliver(snapshot);

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (_, index) => InfoBitCard(snapshot.data[index]),
            childCount: snapshot.data.size,
          ),
        );
      },
    );
  }
}
