import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:hpi_flutter/app/widgets/dashboard_page.dart';
import 'package:hpi_flutter/core/localizations.dart';
import 'package:hpi_flutter/core/widgets/paginated_sliver_list.dart';
import 'package:hpi_flutter/news/data/article.dart';
import 'package:hpi_flutter/news/data/bloc.dart';
import 'package:hpi_flutter/news/utils.dart';
import 'package:provider/provider.dart';

import '../../route.dart';

class NewsFragment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DashboardFragment(
      title: HpiL11n.get(context, 'news'),
      child: ProxyProvider<Uri, NewsBloc>(
        builder: (_, serverUrl, __) => NewsBloc(serverUrl),
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
                child: ArticlePreview(article),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

@immutable
class ArticlePreview extends StatelessWidget {
  final Article article;

  ArticlePreview(this.article) : assert(article != null);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 16 / 9,
          child: article.cover != null
              ? CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: article.cover.source,
                )
              : Padding(
                  padding: EdgeInsets.all(16),
                  child: Image.asset('assets/logo/logo_text.png'),
                ),
        ),
        Positioned.fill(
          child: _buildScrim(
            child: _buildLaunchable(
                context: context,
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        article.title,
                        style: Theme.of(context)
                            .textTheme
                            .body1
                            .copyWith(color: Colors.white),
                        maxLines: 3,
                      ),
                      StreamBuilder<Source>(
                        stream: Provider.of<NewsBloc>(context)
                            .getSource(article.sourceId),
                        builder: (context, snapshot) {
                          return Text(
                            formatSourcePublishDate(article, snapshot.data),
                            style: Theme.of(context)
                                .textTheme
                                .caption
                                .copyWith(color: Colors.white),
                          );
                        },
                      )
                    ],
                  ),
                )),
          ),
        )
      ],
    );
  }

  Widget _buildScrim({Widget child}) {
    assert(child != null);

    return DecoratedBox(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.transparent, Colors.black45],
      )),
      child: child,
    );
  }

  Widget _buildLaunchable({BuildContext context, Widget child}) {
    assert(child != null);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, Route.newsArticle.name,
            arguments: article.id),
        child: child,
      ),
    );
  }
}
