import '../common/page.dart';

import '../../tools/strings.dart';

class Book {
  String _id, _title, _description, _authorId;
  DateTime _modifiedUtc, _createdUtc;

  Book(this._id, this._title, this._description, this._authorId,
      this._modifiedUtc, this._createdUtc);

  factory Book.fromJson(Map<String, dynamic> json) => Book(
      json['id'],
      json['title'],
      json['description'],
      json['authorId'],
      DateTime.parse(json["modifiedUtc"]),
      DateTime.parse(json["createdUtc"]));

  factory Book.empty() =>
      Book(null, "", "", null, DateTime.now().toUtc(), DateTime.now().toUtc());

  String get id => _id;
  String get title => _title;
  String get description => _description;
  DateTime get modifiedUtc => _modifiedUtc;
  DateTime get createdUtc => _createdUtc;
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

  Map toJson() => {
        "id": _id,
        "title": _title,
        "authorId": _authorId,
        "description": _description,
        "modifiedUtc": _modifiedUtc.toIso8601String(),
        "createdUtc": _createdUtc.toIso8601String()
      };
}

JsonDecoder<Book> _bookJsonDecoder =
    (Map<String, dynamic> json) => Book.fromJson(json);

class BooksPage extends Page<Book> {
  BooksPage(PageInfo info, List<Book> elements) : super(info, elements);

  BooksPage.empty() : super(PageInfo(0, 0, 0), List<Book>());

  BooksPage.fromJson(Map<String, dynamic> json)
      : super.fromJson(_bookJsonDecoder, json);
}
