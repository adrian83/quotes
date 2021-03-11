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

  Author.fromJson(Map<String, dynamic> json)
      : this(json[idLabel], json[nameLabel], json[descriptionLabel], DateTime.parse(json[modifiedUtcLabel]), DateTime.parse(json[createdUtcLabel]));

  Map toJson() => super.toJson()..addAll({nameLabel: name, descriptionLabel: description});

@override
  Map<dynamic, dynamic> toUpdate() => toJson()..remove(createdUtcF);

  String toString() =>
      "Author [$idLabel: $id, $nameLabel: $name, $descriptionLabel: $description, $modifiedUtcLabel: $modifiedUtc, $createdUtcLabel: $createdUtc]";
}

class AuthorEvent extends Event<Author> with Document {
  AuthorEvent(String id, String operation, Author author, DateTime modified, DateTime created) : super(id, operation, author, modified, created);

  AuthorEvent.create(Author author) : super(Uuid().v4(), Event.created, author, DateTime.now().toUtc(), DateTime.now().toUtc());

  AuthorEvent.update(Author author) : super(Uuid().v4(), Event.modified, author, DateTime.now().toUtc(), DateTime.now().toUtc());

  AuthorEvent.delete(Author author) : super(Uuid().v4(), Event.deleted, author, DateTime.now().toUtc(), DateTime.now().toUtc());

  AuthorEvent.fromJson(Map<String, dynamic> json)
      : super(json[idLabel], json[operationF], Author.fromJson(json[entityF]), DateTime.parse(json[modifiedUtcLabel]), DateTime.parse(json[createdUtcLabel]));

  String getId() => this.id;

  String toString() =>
      "AuthorEvent [$idLabel: $id, $operationLabel: $operation, $modifiedUtcLabel: $modifiedUtc, $createdUtcLabel: $createdUtc author: ${entity.toString()}]";
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
