import 'package:flutter/material.dart' hide Route;
import 'package:flutter_html/flutter_html.dart';
import 'package:hpi_flutter/app/widgets/app_bar.dart';
import 'package:hpi_flutter/app/widgets/main_scaffold.dart';
import 'package:hpi_flutter/app/widgets/utils.dart';
import 'package:hpi_flutter/core/widgets/chip_group.dart';
import 'package:hpi_flutter/core/widgets/image_widget.dart';
import 'package:hpi_flutter/core/widgets/pagination.dart';
import 'package:hpi_flutter/core/widgets/scrim_around.dart';
import 'package:hpi_flutter/core/widgets/stream_chip.dart';
import 'package:hpi_flutter/myhpi/data/bloc.dart';
import 'package:hpi_flutter/myhpi/data/infobit.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'infobit_card.dart';

@immutable
class InfoBitPage extends StatelessWidget {
  const InfoBitPage({Key key, this.infoBitId}) : super(key: key);

  final String infoBitId;

  @override
  Widget build(BuildContext context) {
    return ProxyProvider<Uri, MyHpiBloc>(
      builder: (_, serverUrl, __) => MyHpiBloc(serverUrl),
      child: MainScaffold(
        body: Builder(
          builder: (context) => _buildContent(context),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    assert(context != null);

    return StreamBuilder<InfoBit>(
      stream: Provider.of<MyHpiBloc>(context).getInfoBit(infoBitId),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return buildLoadingErrorScaffold(context, snapshot);

        final infoBit = snapshot.data;
        return CustomScrollView(
          slivers: <Widget>[
            _buildAppBar(context, infoBit),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Html(
                  data: infoBit.description,
                  onLinkTap: (url) async {
                    if (await canLaunch(url)) await launch(url);
                  },
                ),
              ),
            ),
            if (infoBit.childDisplay != InfoBitChildDisplay.none)
              _buildChildren(context, infoBit),
            if (infoBit.parentId != null) _buildParentLink(context, infoBit),
            SliverPadding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
              sliver: SliverList(
                delegate: SliverChildListDelegate.fixed([
                  if (infoBit.actionIds.isNotEmpty() ||
                      infoBit.tagIds.isNotEmpty())
                    SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ChipGroup(
                      children: infoBit.actionIds
                          .map((a) => InfoBitActionChip(a))
                          .asList(),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Builder(
                      builder: (context) => ChipGroup(
                        title: Text('Tags'),
                        children: infoBit.tagIds
                            .map((t) => StreamChip<InfoBitTag>(
                                  stream:
                                      Provider.of<MyHpiBloc>(context).getTag(t),
                                  labelBuilder: (i) => Text(i.title),
                                ))
                            .asList(),
                      ),
                    ),
                  )
                ]),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAppBar(BuildContext context, InfoBit infoBit) {
    assert(context != null);
    assert(infoBit != null);

    final title = buildAppBarTitle(
      context: context,
      title: Text(infoBit.title),
      subtitle: infoBit.subtitle != null ? Text(infoBit.subtitle) : null,
    );

    if (infoBit.cover == null)
      return HpiSliverAppBar(
        title: title,
      );

    return HpiSliverAppBar(
      expandedHeight: MediaQuery.of(context).size.width / 16 * 9,
      pinned: true,
      flexibleSpace: HpiFlexibleSpaceBar(
        title: title,
        background: DecoratedBox(
          decoration: ScrimAround.simpleBottomScrim(Brightness.light),
          position: DecorationPosition.foreground,
          child: ImageWidget(infoBit.cover),
        ),
      ),
    );
  }

  Widget _buildChildren(BuildContext context, InfoBit infoBit) {
    assert(context != null);
    assert(infoBit != null);

    Widget child;
    switch (infoBit.childDisplay) {
      case InfoBitChildDisplay.list:
        child = PaginatedSliverList<InfoBit>(
          pageSize: 15,
          dataLoader: ({pageSize, pageToken}) {
            return Provider.of<MyHpiBloc>(context).getInfoBits(
                parentId: infoBit.id, pageSize: pageSize, pageToken: pageToken);
          },
          itemBuilder: (_, infoBit, __) => InfoBitListTile(infoBit),
        );
        break;
      case InfoBitChildDisplay.previews:
        child = SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          sliver: PaginatedSliverGrid<InfoBit>.extent(
            maxCrossAxisExtent: 500,
            childAspectRatio: 16 / 9,
            spacing: 8,
            pageSize: 5,
            dataLoader: ({pageSize, pageToken}) {
              return Provider.of<MyHpiBloc>(context).getInfoBits(
                  parentId: infoBit.id,
                  pageSize: pageSize,
                  pageToken: pageToken);
            },
            itemBuilder: (_, infoBit, __) => InfoBitPreviewBox(infoBit),
          ),
        );
        break;
      default:
        break;
    }
    return SliverPadding(
      padding: EdgeInsets.only(bottom: 8),
      sliver: child,
    );
  }

  Widget _buildParentLink(BuildContext context, InfoBit infoBit) {
    assert(context != null);
    assert(infoBit != null);

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Found under',
              style: Theme.of(context).textTheme.overline,
            ),
          ),
          StreamBuilder<InfoBit>(
            stream:
                Provider.of<MyHpiBloc>(context).getInfoBit(infoBit.parentId),
            builder: (_, snapshot) {
              if (!snapshot.hasData) return buildLoadingError(snapshot);

              return InfoBitListTile(snapshot.data);
            },
          ),
        ],
      ),
    );
  }
}
