import 'package:flutter/foundation.dart';
import 'package:grpc/grpc.dart';
import 'package:hpi_flutter/app/app.dart';
import 'package:hpi_flutter/core/core.dart';
import 'package:hpi_flutter/hpi_cloud_apis/hpi/cloud/news/v1test/news_service.pbgrpc.dart';

import 'data.dart';

@immutable
class NewsBloc {
  NewsBloc()
      : _client = NewsServiceClient(
          services.get<ClientChannel>(),
          options: createCallOptions(),
        );

  final NewsServiceClient _client;

  Stream<PaginationResponse<Article>> getArticles({
    int pageSize,
    String pageToken,
  }) {
    final request = ListArticlesRequest()
      ..pageSize = pageSize ?? 0
      ..pageToken = pageToken ?? '';
    return Stream.fromFuture(_client.listArticles(request))
        .map((r) => PaginationResponse(
              r.articles.map((a) => Article.fromProto(a)).toList(),
              r.nextPageToken,
            ));
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
