import 'package:flutter/material.dart' hide Route;
import 'package:flutter_html/flutter_html.dart';
import 'package:hpi_flutter/app/app.dart';
import 'package:hpi_flutter/app/widgets/app_bar.dart';
import 'package:hpi_flutter/app/widgets/utils.dart';
import 'package:hpi_flutter/core/localizations.dart';
import 'package:hpi_flutter/core/utils.dart';
import 'package:hpi_flutter/core/widgets/chip_group.dart';
import 'package:hpi_flutter/core/widgets/image_widget.dart';
import 'package:hpi_flutter/core/widgets/pagination.dart';
import 'package:hpi_flutter/core/widgets/scrim_around.dart';
import 'package:hpi_flutter/core/widgets/stream_chip.dart';
import 'package:hpi_flutter/myhpi/data/bloc.dart';
import 'package:hpi_flutter/myhpi/data/infobit.dart';

import 'infobit_card.dart';

@immutable
class InfoBitPage extends StatelessWidget {
  const InfoBitPage({Key key, this.infoBitId}) : super(key: key);

  final String infoBitId;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<InfoBit>(
      stream: services.get<MyHpiBloc>().getInfoBit(infoBitId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return buildLoadingErrorScaffold(context, snapshot);
        }

        final infoBit = snapshot.data;
        return CustomScrollView(
          slivers: <Widget>[
            _buildAppBar(context, infoBit),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: infoBit.content != null
                    ? Html(
                        data: infoBit.content,
                        onLinkTap: tryLaunch,
                      )
                    : Text(infoBit.description),
              ),
            ),
            if (infoBit.childDisplay != null &&
                infoBit.childDisplay != InfoBitChildDisplay.none)
              _buildChildren(context, infoBit),
            if (infoBit.parentId != null) _buildParentLink(context, infoBit),
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                16,
                infoBit.actionIds.isNotEmpty() || infoBit.tagIds.isNotEmpty()
                    ? 16
                    : 0,
                16,
                16,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate.fixed([
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
                        title: Text(
                          HpiL11n.get(context, 'myhpi/infoBit.tags.title'),
                        ),
                        children: infoBit.tagIds
                            .map((t) => StreamChip<InfoBitTag>(
                                  stream: services.get<MyHpiBloc>().getTag(t),
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

    if (infoBit.cover == null) {
      return HpiSliverAppBar(
        title: title,
      );
    }

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

    switch (infoBit.childDisplay) {
      case InfoBitChildDisplay.list:
        return SliverPadding(
          padding: EdgeInsets.only(top: 16),
          sliver: PaginatedSliverList<InfoBit>(
            pageSize: 15,
            dataLoader: ({pageSize, pageToken}) {
              return services.get<MyHpiBloc>().getInfoBits(
                  parentId: infoBit.id,
                  pageSize: pageSize,
                  pageToken: pageToken);
            },
            itemBuilder: (_, infoBit, __) => InfoBitListTile(infoBit),
          ),
        );
      case InfoBitChildDisplay.previews:
        return SliverPadding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
          sliver: PaginatedSliverGrid<InfoBit>.extent(
            maxCrossAxisExtent: 500,
            childAspectRatio: 16 / 9,
            spacing: 8,
            pageSize: 5,
            dataLoader: ({pageSize, pageToken}) {
              return services.get<MyHpiBloc>().getInfoBits(
                  parentId: infoBit.id,
                  pageSize: pageSize,
                  pageToken: pageToken);
            },
            itemBuilder: (_, infoBit, __) => InfoBitPreviewBox(infoBit),
          ),
        );
      default:
        assert(false,
            '_buildChildren must not be called for InfoBitChildDisplay.none');
        return Container();
    }
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
              HpiL11n.get(context, 'myhpi/infoBit.parent'),
              style: Theme.of(context).textTheme.overline,
            ),
          ),
          StreamBuilder<InfoBit>(
            stream: services.get<MyHpiBloc>().getInfoBit(infoBit.parentId),
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
