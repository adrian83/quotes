import '../common/page.dart';
import '../common/model.dart';

import '../../tools/strings.dart';

class Book extends Entity {
  String _title, _description, _authorId;

  Book(String id, this._title, this._description, this._authorId,
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

  Book.empty() : this(null, "", "", null, nowUtc(), nowUtc());

  String get title => _title;
  String get description => _description;
  List<String> get descriptionParts => _description.split("\n");
  String get shortDescription => shorten(_description, 250);
  String get authorId => _authorId;

  void set title(String title) {
    this._title = title;
  }

  void set authorId(String authorId) {
    this._authorId = authorId;
  }

  void set description(String desc) {
    this._description = desc;
  }

  Map toJson() => super.toJson()
    ..addAll(
        {"title": _title, "authorId": _authorId, "description": _description});
}

JsonDecoder<Book> _bookJsonDecoder =
    (Map<String, dynamic> json) => Book.fromJson(json);

class BooksPage extends Page<Book> {
  BooksPage(PageInfo info, List<Book> elements) : super(info, elements);

  BooksPage.empty() : super(PageInfo(0, 0, 0), List<Book>());

  BooksPage.fromJson(Map<String, dynamic> json)
      : super.fromJson(_bookJsonDecoder, json);
}
