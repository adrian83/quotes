import 'package:uuid/uuid.dart';

import '../common/model.dart';

import '../../tools/elasticsearch/document.dart';

class Author extends Entity {
  String _name, _description;

  Author(String id, this._name, this._description, DateTime modifiedUtc,
      DateTime createdUtc)
      : super(id, modifiedUtc, createdUtc);

  factory Author.fromJson(Map<String, dynamic> json) => Author(
      json['id'],
      json['name'],
      json['description'],
      DateTime.parse(json['modifiedUtc']),
      DateTime.parse(json['createdUtc']));

  factory Author.fromDB(List<dynamic> row) => Author(row[0].toString().trim(),
      row[1].toString().trim(), row[2].toString().trim(), row[3], row[4]);

  String get name => _name;
  String get description => _description;

  Author generateId() {
    id = Uuid().v4();
    return this;
  }

  Map toJson() =>
      super.toJson()..addAll({"name": _name, "description": _description});
}

class AuthorEvent extends ESDocument implements Jsonable {
  Author _author;

  AuthorEvent(String eventId, String operation, this._author)
      : super(eventId, operation);

  factory AuthorEvent.created(String eventId, Author author) =>
      AuthorEvent(eventId, ESDocument.created, author);

  factory AuthorEvent.modified(String eventId, Author author) =>
      AuthorEvent(eventId, ESDocument.modified, author);

  factory AuthorEvent.deleted(String eventId, Author author) =>
      AuthorEvent(eventId, ESDocument.deleted, author);

  factory AuthorEvent.fromJson(Map<String, dynamic> json) =>
      AuthorEvent(json['eventId'], json['operation'], Author.fromJson(json));

  Author get author => _author;

  Map toJson() => super.toJson()..addAll(_author.toJson());
}
