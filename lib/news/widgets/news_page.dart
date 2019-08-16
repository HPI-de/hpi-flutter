import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hpi_flutter/app/widgets/main_scaffold.dart';
import 'package:hpi_flutter/news/data/article.dart';
import 'package:kt_dart/collection.dart';
import 'package:provider/provider.dart';

import '../data/bloc.dart';
import 'article_preview.dart';

@immutable
class NewsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProxyProvider<Uri, NewsBloc>(
      builder: (_, serverUrl, __) => NewsBloc(serverUrl),
      child: MainScaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              floating: true,
              title: Text('News'),
            ),
            Builder(builder: (c) => _buildArticleList(c)),
          ],
        ),
      ),
    );
  }

  Widget _buildArticleList(BuildContext context) {
    return StreamBuilder<KtList<Article>>(
      stream: Provider.of<NewsBloc>(context).getArticles(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return SliverFillRemaining(
            child: Center(
              child: snapshot.hasError
                  ? Text(snapshot.error.toString())
                  : CircularProgressIndicator(),
            ),
          );

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => ArticlePreview(snapshot.data[index]),
            childCount: snapshot.data.size,
          ),
        );
      },
    );
  }
}
