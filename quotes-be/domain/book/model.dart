
import '../common/model.dart';

import '../../store/document.dart';

class Book extends Entity {
  String _title, _description, _authorId;

  Book(String id, this._title, this._description, this._authorId, [DateTime createdUtc]) : super(id, createdUtc);

  factory Book.fromJson(Map<String, dynamic> json) =>
      Book(json['id'], json['title'], json['description'], json['authorId']);

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

class BookEvent extends Book implements ESDocument {

  BookEvent(Book book)
      : super(book.id, book.title, book.description, book.authorId, book.createdUtc);
}
