import 'package:flutter/material.dart';
import 'package:hpi_flutter/app/widgets/app_bar.dart';
import 'package:hpi_flutter/app/widgets/main_scaffold.dart';
import 'package:hpi_flutter/core/widgets/paginated_sliver_list.dart';
import 'package:hpi_flutter/myhpi/data/bloc.dart';
import 'package:provider/provider.dart';

import 'infobit_card.dart';

class MyHpiPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProxyProvider<Uri, MyHpiBloc>(
      builder: (_, serverUrl, __) => MyHpiBloc(serverUrl),
      child: MainScaffold(
        body: CustomScrollView(slivers: <Widget>[
          HpiSliverAppBar(
            title: Text('MyHPI'),
          ),
          InfoBitList(),
        ]),
      ),
    );
  }
}

class InfoBitList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PaginatedSliverList(
      pageSize: 10,
      dataLoader: Provider.of<MyHpiBloc>(context).getInfoBits,
      itemBuilder: (_, infoBit, __) => InfoBitCard(infoBit),
    );
  }
}
