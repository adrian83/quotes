import 'package:uuid/uuid.dart';

import 'package:quotesbe/domain/common/model.dart';
import 'package:quotesbe/domain/common/exception.dart';
import 'package:quotes_common/domain/entity.dart';
import 'package:quotes_common/domain/author.dart';
import 'package:quotes_common/util/time.dart';

class AuthorDocument extends Author implements EntityDocument {
  AuthorDocument(super.id, super.name, super.description, super.modifiedUtc, super.createdUtc);

  AuthorDocument.fromModel(Author author) : this(author.id, author.name, author.description, author.modifiedUtc, author.createdUtc);

  AuthorDocument.create(super.name, String super.description) : super.create();

  AuthorDocument.update(String id, String name, String description) : super(id, name, description, nowUtc(), nowUtc());

  AuthorDocument.fromJson(Map<String, dynamic> json)
      : this(
          json[fieldEntityId],
          json[fieldAuthorName],
          json[fieldAuthorDescription],
          fromString(json[fieldEntityModifiedUtc]),
          fromString(json[fieldEntityCreatedUtc]),
        );

  @override
  Map<dynamic, dynamic> toSave() => toJson();

  @override
  Map<dynamic, dynamic> toUpdate() => toJson()..remove(fieldEntityCreatedUtc);

  @override
  String toString() =>
      "Author [$fieldEntityId: $id, $fieldAuthorName: $name, $fieldAuthorDescription: $description, $fieldEntityModifiedUtc: $modifiedUtc, $fieldEntityCreatedUtc: $createdUtc]";

  @override
  String getId() => super.id;
}

class AuthorEvent extends Event<AuthorDocument> implements EntityDocument {
  AuthorEvent(super.id, super.operation, super.author, super.modified, super.created);

  AuthorEvent.operation(AuthorDocument author, String operation) : super(const Uuid().v4(), operation, author, nowUtc(), nowUtc());

  AuthorEvent.create(AuthorDocument author) : this.operation(author, Event.created);

  AuthorEvent.update(AuthorDocument author) : this.operation(author, Event.modified);

  AuthorEvent.delete(AuthorDocument author) : this.operation(author, Event.deleted);

  AuthorEvent.fromJson(Map<String, dynamic> json)
      : super(
          json[fieldEntityId],
          json[operationLabel],
          AuthorDocument.fromJson(json[entityLabel]),
          fromString(json[fieldEntityModifiedUtc]),
          fromString(json[fieldEntityCreatedUtc]),
        );

  @override
  Map<dynamic, dynamic> toJson() => {
        fieldEntityId: id,
        operationLabel: operation,
        fieldEntityModifiedUtc: modifiedUtc.toIso8601String(),
        fieldEntityCreatedUtc: createdUtc.toIso8601String(),
        entityLabel: entity.toJson(),
      };

  @override
  String toString() =>
      "AuthorEvent [$fieldEntityId: $id, $operationLabel: $operation, $fieldEntityModifiedUtc: $modifiedUtc, $fieldEntityCreatedUtc: $createdUtc, $entityLabel: ${entity.toString()}]";

  @override
  String getId() => id;

  @override
  Map toSave() => toJson();

  @override
  Map toUpdate() => throw EventModificationException();
}
