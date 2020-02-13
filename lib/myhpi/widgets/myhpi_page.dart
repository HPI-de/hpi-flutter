import 'package:flutter/material.dart';
import 'package:hpi_flutter/app/app.dart';
import 'package:hpi_flutter/app/widgets/app_bar.dart';
import 'package:hpi_flutter/app/widgets/main_scaffold.dart';
import 'package:hpi_flutter/core/localizations.dart';
import 'package:hpi_flutter/core/widgets/pagination.dart';
import 'package:hpi_flutter/myhpi/data/bloc.dart';
import 'package:hpi_flutter/myhpi/data/infobit.dart';

import 'infobit_card.dart';

class MyHpiPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          HpiSliverAppBar(
            title: Text(HpiL11n.get(context, 'myhpi')),
          ),
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
