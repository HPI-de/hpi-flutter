import 'package:timeago/timeago.dart' as timeago;

import 'data.dart';

String formatSourcePublishDate(Article article, Source source) {
  assert(article != null);

  String sourceName = source?.name ?? article.sourceId;
  return (sourceName.isNotEmpty ? '$sourceName · ' : '') +
      timeago.format(article.publishDate.toDateTimeLocal());
}
