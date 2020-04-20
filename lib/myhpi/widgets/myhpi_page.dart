import 'package:flutter/material.dart';
import 'package:hpi_flutter/app/app.dart';
import 'package:hpi_flutter/core/core.dart';

import '../bloc.dart';
import '../data.dart';
import 'infobit_card.dart';

class MyHpiPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          HpiSliverAppBar(title: Text(context.s.myhpi)),
          InfoBitList(),
        ],
      ),
    );
  }
}

class InfoBitList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PaginatedSliverList<InfoBit>(
      pageSize: 10,
      dataLoader: services.get<MyHpiBloc>().getInfoBits,
      itemBuilder: (_, infoBit, __) => InfoBitCard(infoBit),
    );
  }
}
