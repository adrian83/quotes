import 'package:uuid/uuid.dart';

import 'package:quotesbe2/domain/common/model.dart';

const authorNameLabel = 'name';
const authorDescLabel = 'description';

class Author extends Entity {
  String name, description;

  Author(
    String id,
    this.name,
    this.description,
    DateTime modifiedUtc,
    DateTime createdUtc,
  ) : super(id, modifiedUtc, createdUtc);

  Author.create(this.name, this.description) : super.create();

  Author.update(String id, this.name, this.description)
      : super(id, nowUtc(), nowUtc());

  Author.fromJson(Map<String, dynamic> json)
      : this(
          json[idLabel],
          json[authorNameLabel],
          json[authorDescLabel],
          DateTime.parse(json[modifiedUtcLabel]),
          DateTime.parse(json[createdUtcLabel]),
        );

  @override
  Map<dynamic, dynamic> toJson() => super.toJson()
    ..addAll({authorNameLabel: name, authorDescLabel: description});

  @override
  Map<dynamic, dynamic> toSave() => toJson();

  @override
  Map<dynamic, dynamic> toUpdate() => toJson()..remove(createdUtcLabel);

  @override
  String toString() =>
      "Author [$idLabel: $id, $authorNameLabel: $name, $authorDescLabel: $description, $modifiedUtcLabel: $modifiedUtc, $createdUtcLabel: $createdUtc]";
}

class AuthorEvent extends Event<Author> {
  AuthorEvent(
    String id,
    String operation,
    Author author,
    DateTime modified,
    DateTime created,
  ) : super(id, operation, author, modified, created);

  AuthorEvent.operation(Author author, String operation)
      : super(const Uuid().v4(), operation, author, nowUtc(), nowUtc());

  AuthorEvent.create(Author author) : this.operation(author, Event.created);

  AuthorEvent.update(Author author) : this.operation(author, Event.modified);

  AuthorEvent.delete(Author author) : this.operation(author, Event.deleted);

  AuthorEvent.fromJson(Map<String, dynamic> json)
      : super(
          json[idLabel],
          json[operationLabel],
          Author.fromJson(json[entityLabel]),
          DateTime.parse(json[modifiedUtcLabel]),
          DateTime.parse(json[createdUtcLabel]),
        );

  @override
  Map<dynamic, dynamic> toJson() => {
        idLabel: id,
        operationLabel: operation,
        modifiedUtcLabel: modifiedUtc.toIso8601String(),
        createdUtcLabel: createdUtc.toIso8601String(),
        entityLabel: entity.toJson()
      };

  @override
  String toString() =>
      "AuthorEvent [$idLabel: $id, $operationLabel: $operation, $modifiedUtcLabel: $modifiedUtc, $createdUtcLabel: $createdUtc, $entityLabel: ${entity.toString()}]";
}
