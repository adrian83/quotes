import '../../store/document.dart';
import '../common/model.dart';

class Author extends Entity {
  String _name, _description;

  Author(String id, this._name, this._description, [DateTime createdUtc])
      : super(id, createdUtc);

  factory Author.fromJson(Map<String, dynamic> json) =>
      Author(json['id'], json['name'], json['description']);

  factory Author.fromDB(List<dynamic> row) => Author(row[0].toString().trim(),
      row[1].toString().trim(), row[2].toString().trim(), row[3]);

  String get name => _name;
  String get description => _description;

  Map toJson() =>
      super.toJson()..addAll({"name": _name, "description": _description});
}

class AuthorEvent extends ESDocument {
  Author _author;

  AuthorEvent(String docId, String operation, this._author)
      : super(docId, operation);

  factory AuthorEvent.created(String docId, Author author) =>
      AuthorEvent(docId, ESDocument.created, author);

  factory AuthorEvent.modified(String docId, Author author) =>
      AuthorEvent(docId, ESDocument.modified, author);

  factory AuthorEvent.deleted(String docId, Author author) =>
      AuthorEvent(docId, ESDocument.deleted, author);

  Author get author => _author;

  Map toJson() => super.toJson()..addAll(_author.toJson());
}
