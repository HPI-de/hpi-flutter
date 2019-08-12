import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grpc/grpc.dart';
import 'package:hpi_flutter/app/widgets/main_scaffold.dart';
import 'package:hpi_flutter/news/data/article.dart';
import 'package:kt_dart/collection.dart';
import 'package:provider/provider.dart';

import '../bloc.dart';
import 'article_preview.dart';

@immutable
class NewsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProxyProvider<ClientChannel, NewsBloc>(
      builder: (_, channel, __) => NewsBloc(channel),
      child: MainScaffold(
        appBar: AppBar(
          title: Text("News"),
        ),
        body: ArticleList(),
      ),
    );
  }
}

class ArticleList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<KtList<Article>>(
      stream: Provider.of<NewsBloc>(context).getArticles(),
      builder: (context, snapshot) {
        if (snapshot.hasError)
          return Center(
            child: Text(snapshot.error),
          );
        if (!snapshot.hasData) return Placeholder();

        return ListView(
          children: snapshot.data.map((a) => ArticlePreview(a)).asList(),
        );
      },
    );
  }
}
