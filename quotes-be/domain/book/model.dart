import 'package:uuid/uuid.dart';

import '../../tools/elasticsearch/document.dart';
import '../common/model.dart';

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
            DateTime.parse(json['modifiedUtc']),
            DateTime.parse(json['createdUtc']));

  Book.fromDB(List<dynamic> row)
      : this(row[0].toString().trim(), row[1].toString().trim(),
            row[2].toString().trim(), row[3].toString().trim(), row[4], row[5]);

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

class BookEvent extends ESDocument {
  Book _book;

  BookEvent(String docId, String operation, this._book)
      : super(docId, operation);

  BookEvent.created(String docId, Book book)
      : this(docId, ESDocument.created, book);

  BookEvent.modified(String docId, Book book)
      : this(docId, ESDocument.modified, book);

  BookEvent.deleted(String docId, Book book)
      : this(docId, ESDocument.deleted, book);

  BookEvent.fromJson(Map<String, dynamic> json)
      : this(json['eventId'], json['operation'], Book.fromJson(json));

  Book get book => _book;

  Map toJson() => super.toJson()..addAll(_book.toJson());
}
