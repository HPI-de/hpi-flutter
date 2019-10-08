import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:hpi_flutter/app/widgets/dashboard_page.dart';
import 'package:hpi_flutter/core/localizations.dart';
import 'package:hpi_flutter/core/widgets/pagination.dart';
import 'package:hpi_flutter/core/widgets/preview_box.dart';
import 'package:hpi_flutter/news/data/article.dart';
import 'package:hpi_flutter/news/data/bloc.dart';
import 'package:hpi_flutter/news/utils.dart';
import 'package:provider/provider.dart';

import '../../route.dart';

class NewsFragment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DashboardFragment(
      title: Text(HpiL11n.get(context, 'news')),
      child: ProxyProvider<Uri, NewsBloc>(
        builder: (_, serverUrl, __) =>
            NewsBloc(serverUrl, Localizations.localeOf(context)),
        child: SizedBox(
          height: 150,
          child: Builder(
            builder: (context) => PaginatedListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(8),
              pageSize: 5,
              dataLoader: Provider.of<NewsBloc>(context).getArticles,
              itemBuilder: (_, article, __) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ArticlePreviewBox(article),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

@immutable
class ArticlePreviewBox extends StatelessWidget {
  ArticlePreviewBox(this.article) : assert(article != null);

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
        stream: Provider.of<NewsBloc>(context).getSource(article.sourceId),
        builder: (context, snapshot) {
          return Text(
            formatSourcePublishDate(article, snapshot.data),
            style: Theme.of(context)
                .textTheme
                .caption
                .copyWith(color: Colors.white),
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
