import 'package:hpi_flutter/core/core.dart';
import 'package:hpi_flutter/hpi_cloud_apis/google/protobuf/wrappers.pb.dart';
import 'package:hpi_flutter/hpi_cloud_apis/hpi/cloud/news/v1test/article.pb.dart'
    as proto;
import 'package:kt_dart/collection.dart';
import 'package:meta/meta.dart';

@immutable
class Article {
  final String id;
  final String sourceId;
  final Uri link;
  final String title;
  final DateTime publishDate;
  final KtSet<String> authorIds;
  final Image cover;
  final String teaser;
  final String content;
  final KtSet<Category> categories;
  final KtSet<Tag> tags;
  final int viewCount;

  const Article({
    @required this.id,
    @required this.sourceId,
    @required this.link,
    @required this.title,
    @required this.publishDate,
    @required this.authorIds,
    this.cover,
    @required this.teaser,
    @required this.content,
    @required this.categories,
    @required this.tags,
    this.viewCount,
  })  : assert(id != null),
        assert(sourceId != null),
        assert(link != null),
        assert(title != null),
        assert(publishDate != null),
        assert(authorIds != null),
        assert(teaser != null),
        assert(content != null),
        assert(categories != null),
        assert(tags != null);

  Article.fromProto(proto.Article article)
      : this(
          id: article.id,
          sourceId: article.sourceId,
          link: Uri.parse(article.link),
          title: article.title,
          publishDate: timestampToDateTime(article.publishDate),
          authorIds: KtSet.from(article.authorIds),
          cover: article.hasCover() ? Image.fromProto(article.cover) : null,
          teaser: article.teaser,
          content: article.content,
          categories: KtSet.from(article.categories)
              .map((c) => Category.fromProto(c))
              .toSet(),
          tags: KtSet.from(article.tags).map((t) => Tag.fromProto(t)).toSet(),
          viewCount: article.hasViewCount() ? article.viewCount.value : null,
        );
  proto.Article toProto() {
    final a = proto.Article();
    a.id = id;
    a.sourceId = sourceId;
    a.link = link.toString();
    a.title = title;
    a.publishDate = dateTimeToTimestamp(publishDate);
    a.authorIds.addAll(authorIds.iter);
    if (cover != null) a.cover = cover.toProto();
    a.teaser = teaser;
    a.content = content;
    a.categories.addAll(categories.map((c) => c.toProto()).iter);
    a.tags.addAll(tags.map((t) => t.toProto()).iter);
    if (viewCount != null) a.viewCount = UInt32Value()..value = viewCount;
    return a;
  }
}

@immutable
class Source {
  final String id;
  final String name;
  final Uri link;

  const Source({@required this.id, @required this.name, @required this.link})
      : assert(id != null),
        assert(name != null),
        assert(link != null);

  Source.fromProto(proto.Source source)
      : this(
          id: source.id,
          name: source.title,
          link: Uri.parse(source.link),
        );
  proto.Source toProto() {
    return proto.Source()
      ..id = id
      ..title = name
      ..link = link.toString();
  }
}

@immutable
class Category {
  final String id;
  final String name;

  const Category({@required this.id, @required this.name})
      : assert(id != null),
        assert(name != null);

  Category.fromProto(proto.Category category)
      : this(
          id: category.id,
          name: category.title,
        );
  proto.Category toProto() {
    return proto.Category()
      ..id = id
      ..title = name;
  }
}

@immutable
class Tag {
  final String id;
  final String name;
  final int articleCount;

  const Tag(
      {@required this.id, @required this.name, @required this.articleCount})
      : assert(id != null),
        assert(name != null),
        assert(articleCount != null);

  Tag.fromProto(proto.Tag tag)
      : this(
          id: tag.id,
          name: tag.title,
          articleCount: tag.articleCount,
        );
  proto.Tag toProto() {
    return proto.Tag()
      ..id = id
      ..title = name
      ..articleCount = articleCount;
  }
}
