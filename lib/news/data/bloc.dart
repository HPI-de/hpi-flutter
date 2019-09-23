import 'package:flutter/foundation.dart';
import 'package:grpc/grpc.dart';
import 'package:hpi_flutter/hpi_cloud_apis/hpi/cloud/news/v1test/news_service.pbgrpc.dart';
import 'package:kt_dart/collection.dart';

import 'article.dart';

@immutable
class NewsBloc {
  NewsBloc(Uri serverUrl)
      : assert(serverUrl != null),
        _client = NewsServiceClient(
          ClientChannel(
            serverUrl.toString(),
            port: 50061,
            options: ChannelOptions(
              credentials: ChannelCredentials.insecure(),
            ),
          ),
        );

  final NewsServiceClient _client;

  Stream<KtList<Article>> getArticles() {
    return Stream.fromFuture(_client.listArticles(ListArticlesRequest())).map(
        (r) => KtList.from(r.articles)
            .map((a) => Article.fromProto(a))
            .sortedByDescending((a) => a.publishDate));
  }

  Stream<Article> getArticle(String id) {
    assert(id != null);
    return Stream.fromFuture(_client.getArticle(GetArticleRequest()..id = id))
        .map((a) => Article.fromProto(a));
  }

  Stream<Source> getSource(String id) {
    assert(id != null);
    return Stream.fromFuture(_client.getSource(GetSourceRequest()..id = id))
        .map((s) => Source.fromProto(s));
  }
}
