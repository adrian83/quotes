import '../common/model.dart';

import '../../store/document.dart';

class Book extends Entity {
  String _title, _description, _authorId;

  Book(String id, this._title, this._description, this._authorId,
      [DateTime createdUtc])
      : super(id, createdUtc);

  factory Book.fromJson(Map<String, dynamic> json) =>
      Book(json['id'], json['title'], json['description'], json['authorId']);

  factory Book.fromDB(List<dynamic> row) => Book(row[0].toString().trim(),
      row[1].toString().trim(), row[2].toString().trim(), row[3].toString().trim(), row[4]);

  String get title => _title;
  String get description => _description;
  String get authorId => _authorId;

  Map toJson() => super.toJson()
    ..addAll({
      "title": _title,
      "authorId": _authorId,
      "description": _description,
    });
}

class BookEvent extends ESDocument {
  Book _book;

  BookEvent(String docId, String operation, this._book)
      : super(docId, operation);

  factory BookEvent.created(String docId, Book book) =>
      BookEvent(docId, ESDocument.created, book);

  factory BookEvent.modified(String docId, Book book) =>
      BookEvent(docId, ESDocument.modified, book);

  factory BookEvent.deleted(String docId, Book book) =>
      BookEvent(docId, ESDocument.deleted, book);

  Book get book => _book;

  Map toJson() => super.toJson()..addAll(_book.toJson());
}
