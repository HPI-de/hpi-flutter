import 'package:flutter/foundation.dart';
import 'package:grpc/service_api.dart';
import 'package:hpi_flutter/hpi_cloud_apis/hpi/cloud/news/v1test/news_service.pbgrpc.dart';
import 'package:kt_dart/collection.dart';

import 'data/article.dart';

@immutable
class NewsBloc {
  final NewsServiceClient _client;

  NewsBloc(ClientChannel channel)
      : assert(channel != null),
        _client = NewsServiceClient(channel);

  Stream<KtList<Article>> getArticles() {
    return Stream.fromFuture(_client.listArticles(ListArticlesRequest()))
        .map((r) => KtList.from(r.articles).map((a) => Article.fromProto(a)));
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
