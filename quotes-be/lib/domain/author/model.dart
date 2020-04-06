import 'package:uuid/uuid.dart';

import '../../infrastructure/elasticsearch/document.dart';
import '../common/model.dart';

var idLabel = 'id';
var nameLabel = 'name';
var descriptionLabel = 'description';
var modifiedUtcLabel = 'modifiedUtc';
var createdUtcLabel = 'createdUtc';

class Author extends Entity {
  String name, description;

  Author(String id, this.name, this.description, DateTime modifiedUtc, DateTime createdUtc) : super(id, modifiedUtc, createdUtc);

  Author.create(this.name, this.description) : super(Uuid().v4(), DateTime.now().toUtc(), DateTime.now().toUtc());

  Author.update(String id, this.name, this.description) : super(id, DateTime.now().toUtc(), DateTime.now().toUtc());

  Author.fromJson(Map<String, dynamic> json)
      : this(json[idLabel], json[nameLabel], json[descriptionLabel], DateTime.parse(json[modifiedUtcLabel]), DateTime.parse(json[createdUtcLabel]));

  Author.fromDB(List<dynamic> row) : this(row[0].toString().trim(), row[1].toString().trim(), row[2].toString().trim(), row[3], row[4]);

  Map toJson() => super.toJson()..addAll({nameLabel: name, descriptionLabel: description});
}

var eventIdLabel = 'eventId';
var operationLabel = 'operation';

class AuthorEvent extends ESDocument {
  Author author;

  AuthorEvent(String eventId, String operation, this.author) : super(eventId, operation);

  AuthorEvent.created(String eventId, Author author) : this(eventId, ESDocument.created, author);

  AuthorEvent.modified(String eventId, Author author) : this(eventId, ESDocument.modified, author);

  AuthorEvent.deleted(String eventId, Author author) : this(eventId, ESDocument.deleted, author);

  AuthorEvent.fromJson(Map<String, dynamic> json) : this(json[eventIdLabel], json[operationLabel], Author.fromJson(json));

  Map toJson() => super.toJson()..addAll(author.toJson());
}
