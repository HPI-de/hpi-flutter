import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hpi_flutter/app/app.dart';
import 'package:hpi_flutter/core/core.dart';

import '../bloc.dart';
import '../data.dart';
import 'article_preview.dart';

@immutable
class NewsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          HpiSliverAppBar(
            floating: true,
            title: Text(HpiL11n.get(context, 'news')),
          ),
          Builder(builder: (c) => _buildArticleList(c)),
        ],
      ),
    );
  }

  Widget _buildArticleList(BuildContext context) {
    return PaginatedSliverList<Article>(
      pageSize: 10,
      dataLoader: services.get<NewsBloc>().getArticles,
      itemBuilder: (_, article, __) => ArticlePreview(article),
    );
  }
}
