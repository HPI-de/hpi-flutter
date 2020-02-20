import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hpi_flutter/app/app.dart';
import 'package:hpi_flutter/core/core.dart' hide Image;
import 'package:kt_dart/collection.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:share/share.dart';

import '../bloc.dart';
import '../data.dart';
import '../utils.dart';

@immutable
class ArticlePage extends StatelessWidget {
  final String articleId;

  const ArticlePage(this.articleId) : assert(articleId != null);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Article>(
      stream: services.get<NewsBloc>().getArticle(articleId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return buildLoadingErrorScaffold(
            context,
            snapshot,
            appBarElevated: true,
            loadingTitle: HpiL11n.get(context, 'news/article.loading'),
          );
        }

        return MainScaffold(
          body: ArticleView(snapshot.data),
          menuItems: KtList.from([
            PopupMenuItem(
                value: 'openInBrowser',
                child: HpiL11n.text(context, 'openInBrowser')),
          ]),
          menuItemHandler: (value) async {
            switch (value as String) {
              case 'openInBrowser':
                await tryLaunch(snapshot.data.link.toString());
                break;
              default:
                assert(false);
                break;
            }
          },
          bottomActions: KtList.from([
            IconButton(
              icon: Icon(OMIcons.share),
              onPressed: () {
                Share.share(snapshot.data.link.toString());
              },
            )
          ]),
        );
      },
    );
  }
}

@immutable
class ArticleView extends StatelessWidget {
  const ArticleView(this.article) : assert(article != null);

  final Article article;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        HpiSliverAppBar(
          floating: true,
          expandedHeight: 300,
          flexibleSpace: FlexibleSpaceBar(
            background: article.cover != null
                ? Image.network(
                    article.cover.source,
                    fit: BoxFit.cover,
                  )
                : null,
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
                Text(
                  article.title,
                  style: context.theme.textTheme.headline,
                ),
                SizedBox(height: 8),
                _buildCaption(context),
                SizedBox(height: 16),
                Html(
                  data: article.content,
                  onLinkTap: (url) async {
                    await tryLaunch(url);
                  },
                ),
                if (article.authorIds.isNotEmpty() ||
                    article.categories.isNotEmpty() ||
                    article.tags.isNotEmpty())
                  SizedBox(height: 16),
                if (article.authorIds.isNotEmpty())
                  _buildChipSection<String>(
                    context,
                    HpiL11n.get(context, 'news/article.authors'),
                    article.authorIds,
                    (a) => Chip(label: Text(a)),
                  ),
                if (article.categories.isNotEmpty())
                  _buildChipSection<Category>(
                    context,
                    HpiL11n.get(context, 'news/article.categories'),
                    article.categories,
                    (c) => Chip(label: Text(c.name)),
                  ),
                if (article.tags.isNotEmpty())
                  _buildChipSection<Tag>(
                    context,
                    HpiL11n.get(context, 'news/article.tags'),
                    article.tags,
                    (t) => Chip(label: Text(t.name)),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCaption(BuildContext context) {
    // Workaround: Putting a StreamBuilder directly into a SliverChildListDelegate doesn't work as it tries to reuse the
    // old stream after scolling out of and back into view. Builder avoids this by recreating the StreamBuilder and
    // hence the Stream.
    return Builder(
      builder: (_) => StreamBuilder<Source>(
        stream: services.get<NewsBloc>().getSource(article.sourceId),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          var theme = context.theme.textTheme.caption;
          return Text.rich(
            TextSpan(children: <InlineSpan>[
              TextSpan(text: formatSourcePublishDate(article, snapshot.data)),
              if (article.viewCount != null) ...[
                TextSpan(text: " · "),
                WidgetSpan(
                  child: Icon(
                    OMIcons.removeRedEye,
                    color: theme.color,
                    size: theme.fontSize * 1.3,
                  ),
                ),
                TextSpan(text: " " + article.viewCount.toString()),
              ],
            ]),
            style: theme,
          );
        },
      ),
    );
  }

  Widget _buildChipSection<T>(
    BuildContext context,
    String title,
    KtCollection<T> items,
    Widget Function(T) chipBuilder,
  ) {
    assert(context != null);
    assert(title != null);
    assert(items != null);
    assert(chipBuilder != null);

    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: ChipGroup(
        title: Text(title),
        children: items.map((i) => chipBuilder(i)).asList(),
      ),
    );
  }
}
