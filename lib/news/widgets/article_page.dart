import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grpc/grpc.dart';
import 'package:hpi_flutter/app/widgets/main_scaffold.dart';
import 'package:hpi_flutter/news/data/article.dart';
import 'package:kt_dart/collection.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:provider/provider.dart';

import '../bloc.dart';
import '../utils.dart';

@immutable
class ArticlePage extends StatelessWidget {
  final String articleId;

  const ArticlePage(this.articleId) : assert(articleId != null);

  @override
  Widget build(BuildContext context) {
    return ProxyProvider<ClientChannel, NewsBloc>(
      builder: (_, clientChannel, __) => NewsBloc(clientChannel),
      child: Builder(
        builder: (context) => StreamBuilder<Article>(
          stream: Provider.of<NewsBloc>(context).getArticle(articleId),
          builder: (context, snapshot) {
            if (snapshot.hasError)
              return Center(
                child: Text(snapshot.error),
              );
            if (!snapshot.hasData) return Placeholder();

            return MainScaffold(
              appBar: AppBar(
                title: Text(snapshot.data.title),
              ),
              body: ArticleView(snapshot.data),
            );
          },
        ),
      ),
    );
  }
}

@immutable
class ArticleView extends StatelessWidget {
  final Article article;

  const ArticleView(this.article) : assert(article != null);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        if (article.cover != null)
          SliverToBoxAdapter(
            child: Image.network(article.cover.source),
          ),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
                Text(
                  article.title,
                  style: Theme.of(context).textTheme.headline,
                ),
                SizedBox(height: 8),
                _buildCaption(context),
                SizedBox(height: 16),
                Text(article.content),
                if (article.authorIds.isNotEmpty() ||
                    article.categories.isNotEmpty() ||
                    article.tags.isNotEmpty())
                  SizedBox(height: 16),
                if (article.authorIds.isNotEmpty())
                  ..._buildChipSection(
                    context,
                    "Authors",
                    article.authorIds,
                    (a) => Chip(label: Text(a)),
                  ),
                if (article.categories.isNotEmpty())
                  ..._buildChipSection(
                    context,
                    "Categories",
                    article.categories,
                    (c) => Chip(label: Text(c.name)),
                  ),
                if (article.tags.isNotEmpty())
                  ..._buildChipSection(
                    context,
                    "Tags",
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
        stream: Provider.of<NewsBloc>(context).getSource(article.sourceId),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          // TODO: update once Article.view_count is nullable
          var theme = Theme.of(context).textTheme.caption;
          return Text.rich(
            TextSpan(children: <InlineSpan>[
              TextSpan(text: formatSourcePublishDate(article, snapshot.data)),
              if (article.viewCount > 0) ...[
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

  List<Widget> _buildChipSection<T>(BuildContext context, String title,
      KtCollection<T> items, Widget Function(T) chipBuilder) {
    return <Widget>[
      SizedBox(height: 16),
      Text(
        title,
        style: Theme.of(context).textTheme.overline,
      ),
      Wrap(
        children: items.map((i) => chipBuilder(i)).asList(),
      )
    ];
  }
}
