import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:flutter_html/flutter_html.dart';
import 'package:hpi_flutter/core/localizations.dart';
import 'package:hpi_flutter/core/utils.dart';
import 'package:hpi_flutter/core/widgets/chip_group.dart';
import 'package:hpi_flutter/core/widgets/paginated_sliver_list.dart';
import 'package:hpi_flutter/core/widgets/preview_box.dart';
import 'package:hpi_flutter/myhpi/data/bloc.dart';
import 'package:hpi_flutter/myhpi/data/infobit.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoBitCard extends StatelessWidget {
  const InfoBitCard(this.infoBit, {Key key})
      : assert(infoBit != null),
        super(key: key);

  final InfoBit infoBit;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: _buildHead(context),
          ),
          _buildChildren(context),
          _buildFoot(context),
        ].where((w) => w != null).toList(),
      ),
    );
  }

  Widget _buildHead(BuildContext context) {
    assert(context != null);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          infoBit.title,
          style: Theme.of(context).textTheme.headline,
        ),
        if (!isNullOrBlank(infoBit.subtitle))
          Text(
            infoBit.subtitle,
            style: Theme.of(context).textTheme.caption,
          ),
        SizedBox(height: 4),
        if (!isNullOrBlank(infoBit.description))
          Html(
            data: infoBit.description,
            defaultTextStyle: Theme.of(context)
                .textTheme
                .body1
                .copyWith(color: Colors.black.withOpacity(0.6)),
          ),
      ],
    );
  }

  Widget _buildChildren(BuildContext context) {
    assert(context != null);

    Widget child;
    switch (infoBit.childDisplay) {
      case InfoBitChildDisplay.none:
        return null;
      case InfoBitChildDisplay.list:
        child = _buildChildrenList(context);
        break;
      case InfoBitChildDisplay.previews:
        child = _buildChildrenPreviews(context);
        break;
    }
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: child,
    );
  }

  Widget _buildChildrenList(BuildContext context) {
    assert(context != null);

    return StreamBuilder<PaginationResponse<InfoBit>>(
      stream: Provider.of<MyHpiBloc>(context)
          .getInfoBits(parentId: infoBit.id, pageSize: 3),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Container();
        if (snapshot.data.items.isEmpty()) return Container();

        return Column(
          children: <Widget>[
            ...snapshot.data.items
                .map((i) => ListTile(
                      leading: i.cover != null
                          ? Image.network(
                              i.cover.source,
                              fit: BoxFit.cover,
                              width: 56 * 16 / 9,
                              height: 56,
                            )
                          : null,
                      title: Text(i.title, maxLines: 1),
                      subtitle: !isNullOrBlank(i.subtitle)
                          ? Text(i.subtitle, maxLines: 2)
                          : null,
                    ))
                .asList(),
            if (!isNullOrBlank(snapshot.data.nextPageToken))
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: OutlineButton(
                    child: Text('More...'),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildChildrenPreviews(BuildContext context) {
    assert(context != null);

    return SizedBox(
      height: 150,
      child: Builder(
        builder: (context) => PaginatedListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.all(8),
          pageSize: 5,
          dataLoader: ({pageSize, pageToken}) {
            return Provider.of<MyHpiBloc>(context).getInfoBits(
                parentId: infoBit.id, pageSize: pageSize, pageToken: pageToken);
          },
          itemBuilder: (_, i, __) => Padding(
            padding: const EdgeInsets.only(right: 8),
            child: PreviewBox(
              background: i.cover != null
                  ? CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: i.cover.source,
                    )
                  : Padding(
                      padding: EdgeInsets.all(16),
                      child: Image.asset('assets/logo/logo_text.png'),
                    ),
              title: Text(i.title),
              caption: Text(i.subtitle),
              onTap: () {},
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFoot(BuildContext context) {
    assert(context != null);

    if (infoBit.actionIds.isEmpty() && infoBit.tagIds.isEmpty()) return null;

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ChipGroup(
            children: infoBit.actionIds
                .map((a) => StreamBuilder<Action>(
                      stream: Provider.of<MyHpiBloc>(context).getAction(a),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) return Container();
                        if (!snapshot.hasData)
                          return Chip(
                            label: Text(HpiL11n.get(context, 'loading')),
                          );
                        return _buildActionChip(context, snapshot.data);
                      },
                    ))
                .asList(),
          ),
          ChipGroup(
            children: <Widget>[
              Text('Tags:'),
              ...infoBit.tagIds
                  .map((t) => StreamBuilder<InfoBitTag>(
                        stream: Provider.of<MyHpiBloc>(context).getTag(t),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) return Container();
                          return Chip(
                            label: Text(
                              snapshot.data?.title ??
                                  HpiL11n.get(context, 'loading'),
                            ),
                          );
                        },
                      ))
                  .iter,
            ],
          )
        ],
      ),
    );
  }

  Widget _buildActionChip(BuildContext context, Action action) {
    assert(action != null);

    return ActionChip(
      label: Text(action.title),
      onPressed: () async {
        if (action is TextAction)
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Scaffold(
                appBar: AppBar(title: Text(action.title)),
                body: Html(
                  data: action.content,
                ),
              ),
            ),
          );
        else if (action is LinkAction && await canLaunch(action.url))
          await launch(action.url);
      },
    );
  }
}
