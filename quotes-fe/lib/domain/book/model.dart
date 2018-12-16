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

class BookEvent extends Book {
  String _eventId, _operation;

  BookEvent(this._eventId, this._operation, String id, String title,
      String description, String authorId, DateTime modifiedUtc, DateTime createdUtc)
      : super(id, title, description, authorId, modifiedUtc, createdUtc);

  factory BookEvent.fromJson(Map<String, dynamic> json) => BookEvent(
      json["eventId"],
      json["operation"],
      json["id"],
      json["title"],
      json["description"],
      json["authorId"],
      DateTime.parse(json["modifiedUtc"]),
      DateTime.parse(json["createdUtc"]));

  String get eventId => _eventId;
  String get operation => _operation;

  Map toJson() =>
      super.toJson()..addAll({"eventId": _eventId, "operation": _operation});
}

class BooksPage extends Page<Book> {
  BooksPage(PageInfo info, List<Book> elements) : super(info, elements);

  BooksPage.empty() : super(PageInfo(0, 0, 0), List<Book>());

  factory BooksPage.fromJson(Map<String, dynamic> json) {
    var elems = json['elements'] as List;
    var books = elems.map((j) => Book.fromJson(j)).toList();
    var info = PageInfo.fromJson(json['info']);
    return BooksPage(info, books);
  }
}

class BookEventsPage extends Page<BookEvent> {
  BookEventsPage(PageInfo info, List<BookEvent> elements): super(info, elements);

  BookEventsPage.empty() : super(PageInfo(0, 0, 0), List<BookEvent>());

  factory BookEventsPage.fromJson(Map<String, dynamic> json) {
    var elems = json['elements'] as List;
    var books = elems.map((j) => BookEvent.fromJson(j)).toList();
    var info = PageInfo.fromJson(json['info']);
    return BookEventsPage(info, books);
  }
}
