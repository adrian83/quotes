import 'package:uuid/uuid.dart';

import '../common/model.dart';

import '../../tools/elasticsearch/document.dart';

class Book extends Entity {
  String _title, _description, _authorId;

  Book(String id, this._title, this._description, this._authorId,
      DateTime modifiedUtc, DateTime createdUtc)
      : super(id, modifiedUtc, createdUtc);

  factory Book.fromJson(Map<String, dynamic> json) => Book(
      json['id'],
      json['title'],
      json['description'],
      json['authorId'],
      DateTime.parse(json['modifiedUtc']),
      DateTime.parse(json['createdUtc']));

  factory Book.fromDB(List<dynamic> row) => Book(
      row[0].toString().trim(),
      row[1].toString().trim(),
      row[2].toString().trim(),
      row[3].toString().trim(),
      row[4],
      row[5]);

  String get title => _title;
  String get description => _description;
  String get authorId => _authorId;

  Book generateId() {
    id = Uuid().v4();
    return this;
  }

  Map toJson() => super.toJson()
    ..addAll({
      "title": _title,
      "authorId": _authorId,
      "description": _description,
    });
}

class BookEvent extends ESDocument implements Jsonable {
  Book _book;

  BookEvent(String docId, String operation, this._book)
      : super(docId, operation);

  factory BookEvent.created(String docId, Book book) =>
      BookEvent(docId, ESDocument.created, book);

  factory BookEvent.modified(String docId, Book book) =>
      BookEvent(docId, ESDocument.modified, book);

  factory BookEvent.deleted(String docId, Book book) =>
      BookEvent(docId, ESDocument.deleted, book);

  factory BookEvent.fromJson(Map<String, dynamic> json) =>
      BookEvent(json['eventId'], json['operation'], Book.fromJson(json));

  Book get book => _book;

  Map toJson() => super.toJson()..addAll(_book.toJson());
}
