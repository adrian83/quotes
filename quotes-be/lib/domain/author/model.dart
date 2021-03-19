import 'package:uuid/uuid.dart';

import '../common/model.dart';
import '../../infrastructure/elasticsearch/document.dart';

const authorNameLabel = 'name';
const authorDescLabel = 'description';

class Author extends Entity with Document {
  String name, description;

  Author(String id, this.name, this.description, DateTime modifiedUtc, DateTime createdUtc)
      : super(id, modifiedUtc, createdUtc);

  Author.create(this.name, this.description) : super.create();

  Author.update(String id, this.name, this.description) : super(id, nowUtc(), nowUtc());

  Author.fromJson(Map<String, dynamic> json)
      : this(json[idLabel], json[authorNameLabel], json[authorDescLabel], DateTime.parse(json[modifiedUtcLabel]),
            DateTime.parse(json[createdUtcLabel]));

  @override
  String getId() => this.id;

  @override
  Map<dynamic, dynamic> toSave() => toJson();

  @override
  Map<dynamic, dynamic> toUpdate() => toJson()..remove(createdUtcLabel);

  @override
  Map<dynamic, dynamic> toJson() => super.toJson()..addAll({authorNameLabel: name, authorDescLabel: description});

  @override
  String toString() =>
      "Author [$idLabel: $id, $authorNameLabel: $name, $authorDescLabel: $description, " +
      "$modifiedUtcLabel: $modifiedUtc, $createdUtcLabel: $createdUtc]";
}

class AuthorEvent extends Event<Author> with Document {
  AuthorEvent(String id, String operation, Author author, DateTime modified, DateTime created)
      : super(id, operation, author, modified, created);

  AuthorEvent.operation(Author author, String operation) : super(Uuid().v4(), operation, author, nowUtc(), nowUtc());

  AuthorEvent.create(Author author) : this.operation(author, Event.created);

  AuthorEvent.update(Author author) : this.operation(author, Event.modified);

  AuthorEvent.delete(Author author) : this.operation(author, Event.deleted);

  AuthorEvent.fromJson(Map<String, dynamic> json)
      : super(json[idLabel], json[operationLabel], Author.fromJson(json[entityLabel]),
            DateTime.parse(json[modifiedUtcLabel]), DateTime.parse(json[createdUtcLabel]));

  @override
  String getId() => this.id;

  @override
  String toString() =>
      "AuthorEvent [$idLabel: $id, $operationLabel: $operation, $modifiedUtcLabel: $modifiedUtc, " +
      "$createdUtcLabel: $createdUtc, $entityLabel: ${entity.toString()}]";
}

class ListAuthorsRequest {
  late PageRequest pageRequest;

  ListAuthorsRequest(int offset, int limit) {
    pageRequest = PageRequest(limit, offset);
  }

  @override
  String toString() => "ListAuthorsRequest [pageRequest: $pageRequest]";
}

class ListEventsByAuthorRequest {
  String authorId;
  late PageRequest pageRequest;

  ListEventsByAuthorRequest(this.authorId, int offset, int limit) {
    pageRequest = PageRequest(limit, offset);
  }

  @override
  String toString() => "ListEventsByAuthorRequest [authorId: $authorId, pageRequest: $pageRequest]";
}
