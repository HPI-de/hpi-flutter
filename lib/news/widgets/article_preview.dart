import 'package:flutter/material.dart' hide Route;
import 'package:flutter/widgets.dart' hide Route;
import 'package:hpi_flutter/app/app.dart';
import 'package:hpi_flutter/route.dart';

import '../bloc.dart';
import '../data.dart';
import '../utils.dart';

class ArticlePreview extends StatelessWidget {
  const ArticlePreview(this.article) : assert(article != null);

  final Article article;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, Route.newsArticle.name,
              arguments: article.id);
        },
        child: Column(
          children: <Widget>[
            if (article.cover != null) Image.network(article.cover.source),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    article.title,
                    style: context.theme.textTheme.subhead,
                  ),
                  SizedBox(height: 8),
                  Text(
                    article.teaser,
                    style: context.theme.textTheme.body1,
                  ),
                  SizedBox(height: 4),
                  StreamBuilder<Source>(
                    stream:
                        services.get<NewsBloc>().getSource(article.sourceId),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        print(snapshot.error);
                      }

                      return Text(
                        formatSourcePublishDate(article, snapshot.data),
                        style: context.theme.textTheme.caption,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
