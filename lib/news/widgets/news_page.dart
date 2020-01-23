import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hpi_flutter/app/widgets/app_bar.dart';
import 'package:hpi_flutter/app/widgets/main_scaffold.dart';
import 'package:hpi_flutter/core/localizations.dart';
import 'package:hpi_flutter/core/widgets/pagination.dart';
import 'package:hpi_flutter/news/data/article.dart';
import 'package:provider/provider.dart';

import '../data/bloc.dart';
import 'article_preview.dart';

@immutable
class NewsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProxyProvider<Uri, NewsBloc>(
      update: (_, serverUrl, __) =>
          NewsBloc(serverUrl, Localizations.localeOf(context)),
      child: MainScaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            HpiSliverAppBar(
              floating: true,
              title: Text(HpiL11n.get(context, 'news')),
            ),
            Builder(builder: (c) => _buildArticleList(c)),
          ],
        ),
      ),
    );
  }

  Widget _buildArticleList(BuildContext context) {
    return PaginatedSliverList<Article>(
      pageSize: 10,
      dataLoader: Provider.of<NewsBloc>(context).getArticles,
      itemBuilder: (_, article, __) => ArticlePreview(article),
    );
  }
}
