import 'package:flutter/foundation.dart';
import 'package:grpc/grpc.dart';
import 'package:hpi_flutter/core/widgets/pagination.dart';
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

  Stream<PaginationResponse<Article>> getArticles({
    int pageSize,
    String pageToken,
  }) {
    final request = ListArticlesRequest()
      ..pageSize = pageSize ?? 0
      ..pageToken = pageToken ?? '';
    return Stream.fromFuture(_client.listArticles(request))
        .map((r) => PaginationResponse(
              KtList.from(r.articles).map((a) => Article.fromProto(a)),
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
