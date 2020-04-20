import 'package:flutter/material.dart' hide Action, Route;
import 'package:flutter_html/flutter_html.dart';
import 'package:hpi_flutter/app/app.dart';
import 'package:hpi_flutter/core/core.dart';
import 'package:pedantic/pedantic.dart';

import '../bloc.dart';
import '../data.dart';

class InfoBitCard extends StatelessWidget {
  const InfoBitCard(this.infoBit, {Key key})
      : assert(infoBit != null),
        super(key: key);

  final InfoBit infoBit;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: InkWell(
        onTap: () => context.navigator.pushNamed('myhpi/${infoBit.id}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildHead(context),
            _buildChildren(context),
            _buildFoot(context),
            SizedBox(height: 8),
          ].where((w) => w != null).toList(),
        ),
      ),
    );
  }

  Widget _buildHead(BuildContext context) {
    assert(context != null);

    final title = [
      Text(
        infoBit.title,
        style: context.theme.textTheme.headline,
      ),
      if (infoBit.subtitle != null)
        Text(
          infoBit.subtitle,
          style: context.theme.textTheme.subhead,
        ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (infoBit.cover != null)
          Stack(
            children: <Widget>[
              AspectRatio(
                aspectRatio: 16 / 9,
                child: ImageWidget(infoBit.cover),
              ),
              Positioned.fill(
                child: ScrimAround(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: title,
                    ),
                  ),
                ),
              ),
            ],
          ),
        Padding(
          padding:
              EdgeInsets.fromLTRB(16, infoBit.cover == null ? 8 : 0, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (infoBit.cover == null) ...title,
              SizedBox(height: 4),
              if (infoBit.description != null)
                Text(
                  infoBit.description,
                  style: context.theme.textTheme.body1
                      .copyWith(color: Colors.black.withOpacity(0.6)),
                ),
            ],
          ),
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
      padding: EdgeInsets.only(top: 8),
      child: child,
    );
  }

  Widget _buildChildrenList(BuildContext context) {
    assert(context != null);
    final s = context.s;

    return StreamBuilder<PaginationResponse<InfoBit>>(
      stream: services
          .get<MyHpiBloc>()
          .getInfoBits(parentId: infoBit.id, pageSize: 3),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data.items.isEmpty) {
          return Container();
        }

        return Column(
          children: <Widget>[
            ...snapshot.data.items.map((i) => InfoBitListTile(i)),
            if (!isNullOrBlank(snapshot.data.nextPageToken))
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: OutlineButton(
                    onPressed: () =>
                        context.navigator.pushNamed('/myhpi/${infoBit.id}'),
                    child: Text(s.general_more),
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
      child: PaginatedListView<InfoBit>(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(8),
        pageSize: 5,
        dataLoader: ({pageSize, pageToken}) {
          return services.get<MyHpiBloc>().getInfoBits(
              parentId: infoBit.id, pageSize: pageSize, pageToken: pageToken);
        },
        itemBuilder: (_, i, __) => Padding(
          padding: const EdgeInsets.only(right: 8),
          child: InfoBitPreviewBox(i),
        ),
      ),
    );
  }

  Widget _buildFoot(BuildContext context) {
    assert(context != null);

    if (infoBit.actionIds.isEmpty() && infoBit.tagIds.isEmpty()) {
      return null;
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ChipGroup(
            children:
                infoBit.actionIds.map((a) => InfoBitActionChip(a)).asList(),
          ),
          ChipGroup(
            leading: Text(context.s.myhpi_infoBit_tags_leading),
            children: infoBit.tagIds
                .map((t) => StreamChip<InfoBitTag>(
                      stream: services.get<MyHpiBloc>().getTag(t),
                      labelBuilder: (t) => Text(t.title),
                    ))
                .asList(),
          )
        ],
      ),
    );
  }
}

class InfoBitActionChip extends StatelessWidget {
  const InfoBitActionChip(this.actionId, {Key key})
      : assert(actionId != null),
        super(key: key);

  final String actionId;

  @override
  Widget build(BuildContext context) {
    return StreamActionChip<Action>(
      stream: services.get<MyHpiBloc>().getAction(actionId),
      avatarBuilder: (a) => IconWidget(a.icon),
      labelBuilder: (a) => Text(a.title),
      onPressed: (action) async {
        if (action == null) {
          return;
        }

        if (action is TextAction) {
          unawaited(Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Scaffold(
                appBar: AppBar(title: Text(action.title)),
                body: Html(
                  data: action.content,
                ),
              ),
            ),
          ));
        } else if (action is LinkAction) {
          await tryLaunch(action.url);
        }
      },
    );
  }
}

class InfoBitListTile extends StatelessWidget {
  const InfoBitListTile(this.infoBit, {Key key})
      : assert(infoBit != null),
        super(key: key);

  final InfoBit infoBit;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: infoBit.cover != null
          ? ImageWidget(
              infoBit.cover,
              width: 56 * 16 / 9,
              height: 56,
              fallbackShowLogo: false,
            )
          : null,
      title: Text(
        infoBit.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: infoBit.subtitle != null
          ? Text(
              infoBit.subtitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            )
          : null,
      onTap: () => context.navigator.pushNamed('myhpi/${infoBit.id}'),
    );
  }
}

class InfoBitPreviewBox extends StatelessWidget {
  const InfoBitPreviewBox(this.infoBit, {Key key})
      : assert(infoBit != null),
        super(key: key);

  final InfoBit infoBit;

  @override
  Widget build(BuildContext context) {
    return PreviewBox(
      background: ImageWidget(infoBit.cover),
      title: Text(infoBit.title),
      caption: Text(infoBit.subtitle),
      onTap: () => context.navigator.pushNamed('myhpi/${infoBit.id}'),
    );
  }
}
