import 'package:uuid/uuid.dart';

import '../../internal/elasticsearch/document.dart';
import '../common/model.dart';

var idLabel = 'id';
var nameLabel = 'name';
var descriptionLabel = 'description';
var modifiedUtcLabel = 'modifiedUtc';
var createdUtcLabel = 'createdUtc';

class Author extends Entity {
  String _name, _description;

  Author(String id, this._name, this._description, DateTime modifiedUtc,
      DateTime createdUtc)
      : super(id, modifiedUtc, createdUtc);

  Author.create(this._name, this._description)
      : super(Uuid().v4(), DateTime.now().toUtc(), DateTime.now().toUtc());

  Author.fromJson(Map<String, dynamic> json)
      : this(
            json[idLabel],
            json[nameLabel],
            json[descriptionLabel],
            DateTime.parse(json[modifiedUtcLabel]),
            DateTime.parse(json[createdUtcLabel]));

  Author.fromDB(List<dynamic> row)
      : this(row[0].toString().trim(), row[1].toString().trim(),
            row[2].toString().trim(), row[3], row[4]);

  String get name => _name;
  String get description => _description;

  Map toJson() => super.toJson()
    ..addAll({nameLabel: _name, descriptionLabel: _description});
}

var eventIdLabel = 'eventId';
var operationLabel = 'operation';

class AuthorEvent extends ESDocument {
  Author _author;

  AuthorEvent(String eventId, String operation, this._author)
      : super(eventId, operation);
  AuthorEvent.created(String eventId, Author author)
      : this(eventId, ESDocument.created, author);
  AuthorEvent.modified(String eventId, Author author)
      : this(eventId, ESDocument.modified, author);
  AuthorEvent.deleted(String eventId, Author author)
      : this(eventId, ESDocument.deleted, author);
  AuthorEvent.fromJson(Map<String, dynamic> json)
      : this(json[eventIdLabel], json[operationLabel], Author.fromJson(json));

  Author get author => _author;

  Map toJson() => super.toJson()..addAll(_author.toJson());
}
