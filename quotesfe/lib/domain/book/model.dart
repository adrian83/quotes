import 'package:quotesfe/domain/common/page.dart';
import 'package:quotesfe/domain/common/model.dart';
import 'package:quotesfe/tools/strings.dart';

const fieldBookTitle = "title";
const fieldBookDescription = "description";
const fieldBookAuthorId = "authorId";

const _shortDescriptionMaxLen = 250;

class Book extends Entity {
  String title, authorId;
  String? description;

  Book(String? id, this.title, this.description, this.authorId,
      DateTime modifiedUtc, DateTime createdUtc)
      : super(id, modifiedUtc, createdUtc);

  Book.fromJson(Map<String, dynamic> json)
      : this(
            json[fieldEntityId],
            json[fieldBookTitle],
            json[fieldBookDescription],
            json[fieldBookAuthorId],
            DateTime.parse(json[fieldEntityModifiedUtc]),
            DateTime.parse(json[fieldEntityCreatedUtc]));

  List<String> get descriptionParts => description?.split("\n") ?? [];
  String? get shortDescription => shorten(description, _shortDescriptionMaxLen);

  @override
  Map toJson() => super.toJson()
    ..addAll({
      fieldBookTitle: title,
      fieldBookAuthorId: authorId,
      fieldBookDescription: description
    });
}

JsonDecoder<Book> _bookJsonDecoder =
    (Map<String, dynamic> json) => Book.fromJson(json);

class BooksPage extends Page<Book> {
  BooksPage(PageInfo info, List<Book> elements) : super(info, elements);

  BooksPage.empty() : super(PageInfo(0, 0, 0), []);

  BooksPage.fromJson(Map<String, dynamic> json)
      : super.fromJson(_bookJsonDecoder, json);
}
