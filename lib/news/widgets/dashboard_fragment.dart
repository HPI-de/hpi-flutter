import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:hpi_flutter/app/app.dart';
import 'package:hpi_flutter/core/core.dart' hide Image;

import '../../route.dart';
import '../bloc.dart';
import '../data.dart';
import '../utils.dart';

class NewsFragment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DashboardFragment(
      title: Text(HpiL11n.get(context, 'news')),
      child: SizedBox(
        height: 150,
        child: Builder(
          builder: (context) => PaginatedListView<Article>(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(8),
            pageSize: 5,
            dataLoader: services.get<NewsBloc>().getArticles,
            itemBuilder: (_, article, __) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ArticlePreviewBox(article),
            ),
          ),
        ),
      ),
    );
  }
}

class ArticlePreviewBox extends StatelessWidget {
  const ArticlePreviewBox(this.article) : assert(article != null);

  final Article article;

  @override
  Widget build(BuildContext context) {
    return PreviewBox(
      background: article.cover != null
          ? CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: article.cover.source,
            )
          : Padding(
              padding: EdgeInsets.all(16),
              child: Image.asset('assets/logo/logo_text.png'),
            ),
      title: Text(article.title),
      caption: StreamBuilder<Source>(
        stream: services.get<NewsBloc>().getSource(article.sourceId),
        builder: (context, snapshot) {
          return Text(
            formatSourcePublishDate(article, snapshot.data),
            style:
                context.theme.textTheme.caption.copyWith(color: Colors.white),
          );
        },
      ),
      onTap: () {
        Navigator.pushNamed(context, Route.newsArticle.name,
            arguments: article.id);
      },
    );
  }
}
