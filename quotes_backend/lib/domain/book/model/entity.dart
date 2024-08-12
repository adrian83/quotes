import 'package:uuid/uuid.dart';

import 'package:quotes_backend/domain/common/model.dart';
import 'package:quotes_backend/domain/common/exception.dart';
import 'package:quotes_common/domain/entity.dart';
import 'package:quotes_common/domain/book.dart';
import 'package:quotes_common/util/time.dart';

class BookDocument extends Book implements EntityDocument {
  BookDocument(super.id, super.title, super.description, super.authorId, super.modifiedUtc, super.createdUtc);

  BookDocument.fromModel(Book book) : this(book.id, book.title, book.description, book.authorId, book.modifiedUtc, book.createdUtc);

  BookDocument.fromJson(Map<String, dynamic> json)
      : this(
          json[fieldEntityId],
          json[fieldBookTitle],
          json[fieldBookDescription],
          json[fieldBookAuthorId],
          temporary(json, fieldEntityModifiedUtc),
          temporary(json, fieldEntityCreatedUtc),
        );

  @override
  Map<dynamic, dynamic> toSave() => toJson();

  @override
  Map<dynamic, dynamic> toUpdate() => toJson()..remove(fieldEntityCreatedUtc);

  @override
  Map<dynamic, dynamic> toJson() => super.toJson()
    ..addAll({
      fieldBookTitle: title,
      fieldBookAuthorId: authorId,
      fieldBookDescription: description,
    });

  @override
  String toString() =>
      "Book [$fieldEntityId: $id, $fieldBookTitle: $title, $fieldBookDescription: $description, $fieldBookAuthorId: $authorId, $fieldEntityModifiedUtc: $modifiedUtc, $fieldEntityCreatedUtc: $createdUtc]";

  @override
  String getId() => super.id;
}

class BookEvent extends Event<BookDocument> implements EntityDocument {
  BookEvent(
    super.id,
    super.operation,
    super.book,
    super.modified,
    super.created,
  );

  BookEvent.create(BookDocument book) : super(const Uuid().v4(), Event.created, book, nowUtc(), nowUtc());

  BookEvent.update(BookDocument book) : super(const Uuid().v4(), Event.modified, book, nowUtc(), nowUtc());

  BookEvent.delete(BookDocument book) : super(const Uuid().v4(), Event.deleted, book, nowUtc(), nowUtc());

  BookEvent.fromJson(Map<String, dynamic> json)
      : super(
          json[fieldEntityId],
          json[operationLabel],
          BookDocument.fromJson(json[entityLabel]),
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
  String getId() => super.id;

  @override
  String toString() =>
      "BookEvent [$fieldEntityId: $id, $operationLabel: $operation, $fieldEntityModifiedUtc: $modifiedUtc, $fieldEntityCreatedUtc: $createdUtc, $entityLabel: ${entity.toString()}]";

  @override
  Map toSave() => toJson();

  @override
  Map toUpdate() => throw EventModificationException();
}
