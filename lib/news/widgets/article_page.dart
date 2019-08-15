import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grpc/grpc.dart';
import 'package:hpi_flutter/app/widgets/main_scaffold.dart';
import 'package:hpi_flutter/news/data/article.dart';
import 'package:kt_dart/collection.dart';
import 'package:provider/provider.dart';

import '../data/bloc.dart';

@immutable
class ArticlePage extends StatelessWidget {
  final String articleId;

  const ArticlePage(this.articleId) : assert(articleId != null);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Article>(
      stream:
          NewsBloc(Provider.of<ClientChannel>(context)).getArticle(articleId),
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
    );
  }
}

@immutable
class ArticleView extends StatelessWidget {
  final Article article;

  const ArticleView(this.article) : assert(article != null);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(article.content),
        _buildAuthorsCategoriesTags(context),
      ].where((x) => x != null).toList(),
    );
  }

  Widget _buildAuthorsCategoriesTags(BuildContext context) {
    if (article.authorIds.isEmpty() &&
        article.categories.isEmpty() &&
        article.tags.isEmpty()) return null;
    return Column(
      children: <Widget>[
        SizedBox(height: 16),
        ..._buildChipSection(
          context,
          "Authors",
          article.authorIds.toList(),
          (a) => Chip(
            label: Text(a),
          ),
        ),
        ..._buildChipSection(
          context,
          "Categories",
          article.categories.toList(),
          (c) => Chip(
            label: Text(c.name),
          ),
        ),
        ..._buildChipSection(
          context,
          "Tags",
          article.tags.toList(),
          (t) => Chip(
            label: Text(t.name),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildChipSection<T>(BuildContext context, String title,
      KtList<T> items, Widget Function(T) chipBuilder) {
    if (items.isEmpty()) return [];
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
