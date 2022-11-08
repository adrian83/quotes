import 'package:quotesfe/domain/common/page.dart';
import 'package:quotesfe/domain/common/model.dart';

import 'package:quotesfe/tools/strings.dart';

class Book extends Entity {
  String title, authorId;
  String? description;

  Book(String? id, this.title, this.description, this.authorId,
      DateTime modifiedUtc, DateTime createdUtc)
      : super(id, modifiedUtc, createdUtc);

  Book.fromJson(Map<String, dynamic> json)
      : this(
            json['id'],
            json['title'],
            json['description'],
            json['authorId'],
            DateTime.parse(json["modifiedUtc"]),
            DateTime.parse(json["createdUtc"]));

  List<String> get descriptionParts => description?.split("\n") ?? [];
  String? get shortDescription => shorten(description, 250);

  @override
  Map toJson() => super.toJson()
    ..addAll(
        {"title": title, "authorId": authorId, "description": description});
}

JsonDecoder<Book> _bookJsonDecoder =
    (Map<String, dynamic> json) => Book.fromJson(json);

class BooksPage extends Page<Book> {
  BooksPage(PageInfo info, List<Book> elements) : super(info, elements);

  BooksPage.empty() : super(PageInfo(0, 0, 0), []);

  BooksPage.fromJson(Map<String, dynamic> json)
      : super.fromJson(_bookJsonDecoder, json);
}
