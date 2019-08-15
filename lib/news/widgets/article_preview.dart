import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hpi_flutter/news/data/article.dart';
import 'package:hpi_flutter/news/widgets/article_page.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../data/bloc.dart';

@immutable
class ArticlePreview extends StatelessWidget {
  final Article article;

  ArticlePreview(this.article) : assert(article != null);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => ArticlePage(article.id)),
          );
        },
        child: Column(
          children: <Widget>[
            if (article.cover != null) Image.network(article.cover.source),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Column(children: <Widget>[
                Text(
                  article.title,
                  style: Theme.of(context).textTheme.subhead,
                ),
                SizedBox(height: 8),
                Text(
                  article.teaser,
                  style: Theme.of(context).textTheme.body1,
                ),
                SizedBox(height: 4),
                StreamBuilder<Source>(
                  stream: Provider.of<NewsBloc>(context)
                      .getSource(article.sourceId),
                  builder: (context, snapshot) {
                    String source = "";
                    if (snapshot.hasError) print(snapshot.error);
                    source = snapshot?.data?.name ?? article.sourceId;

                    return Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        (source.isNotEmpty ? "$source · " : "") +
                            timeago.format(article.publishDate),
                        style: Theme.of(context).textTheme.caption,
                      ),
                    );
                  },
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
