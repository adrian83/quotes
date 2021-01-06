import 'package:uuid/uuid.dart';

import '../../infrastructure/elasticsearch/document.dart';
import '../common/model.dart';

var idLabel = 'id';
var nameLabel = 'name';
var eventIdLabel = 'eventId';
var operationLabel = 'operation';
var createdUtcLabel = 'createdUtc';
var descriptionLabel = 'description';
var modifiedUtcLabel = 'modifiedUtc';

class Author extends Entity with Document {
  String name, description;

  String getId() => this.id;

  Author(String id, this.name, this.description, DateTime modifiedUtc, DateTime createdUtc) : super(id, modifiedUtc, createdUtc);

  Author.create(this.name, this.description) : super(Uuid().v4(), DateTime.now().toUtc(), DateTime.now().toUtc());

  Author.update(String id, this.name, this.description) : super(id, DateTime.now().toUtc(), DateTime.now().toUtc());

  Author.fromJson(Map<String, dynamic> json)
      : this(json[idLabel], json[nameLabel], json[descriptionLabel], DateTime.parse(json[modifiedUtcLabel]), DateTime.parse(json[createdUtcLabel]));

  Map toJson() => super.toJson()..addAll({nameLabel: name, descriptionLabel: description});

  String toString() => "Author [id: $id, name: $name, description: $description, modifiedUtc: $modifiedUtc, createdUtc: $createdUtc]";
}

class AuthorEvent extends ESDocument {
  Author author;

  AuthorEvent(String eventId, String operation, this.author) : super(eventId, operation);

  AuthorEvent.created(String eventId, Author author) : this(eventId, ESDocument.created, author);

  AuthorEvent.modified(String eventId, Author author) : this(eventId, ESDocument.modified, author);

  AuthorEvent.deleted(String eventId, Author author) : this(eventId, ESDocument.deleted, author);

  AuthorEvent.fromJson(Map<String, dynamic> json) : this(json[eventIdLabel], json[operationLabel], Author.fromJson(json));

  Map toJson() => super.toJson()..addAll(author.toJson());

  String toString() => "AuthorEvent [eventId: $eventId, operation: $operation, modifiedUtc: $modifiedUtc, author: $author]";
}

class ListAuthorsRequest {
  late PageRequest pageRequest;

  ListAuthorsRequest(int offset, int limit) {
    pageRequest = PageRequest(limit, offset);
  }
}

class ListEventsByAuthorRequest {
  String authorId;
  late PageRequest pageRequest;

  ListEventsByAuthorRequest(this.authorId, int offset, int limit) {
    pageRequest = PageRequest(limit, offset);
  }
}
