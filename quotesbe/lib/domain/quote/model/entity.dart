import 'package:uuid/uuid.dart';

import 'package:quotesbe/domain/common/model.dart';
import 'package:quotesbe/domain/common/exception.dart';
import 'package:quotes_common/domain/entity.dart';
import 'package:quotes_common/domain/quote.dart';
import 'package:quotes_common/util/time.dart';

class QuoteDocument extends Quote implements EntityDocument {
  QuoteDocument(super.id, super.text, super.authorId, super.bookId, super.modifiedUtc, super.createdUtc);

  QuoteDocument.fromModel(Quote quote) : this(quote.id, quote.text, quote.authorId, quote.bookId, quote.modifiedUtc, quote.createdUtc);

  QuoteDocument.fromJson(Map<String, dynamic> json)
      : this(
          json[fieldEntityId],
          json[fieldQuoteText],
          json[fieldQuoteAuthorId],
          json[fieldQuoteBookId],
          fromString(json[fieldEntityModifiedUtc]),
          fromString(json[fieldEntityCreatedUtc]),
        );

  @override
  String getId() => id;

  @override
  Map<dynamic, dynamic> toSave() => toJson();

  @override
  Map<dynamic, dynamic> toUpdate() => toJson()..remove(fieldEntityCreatedUtc);

  @override
  Map<dynamic, dynamic> toJson() => super.toJson()
    ..addAll({
      fieldQuoteText: text,
      fieldQuoteAuthorId: authorId,
      fieldQuoteBookId: bookId,
    });

  @override
  String toString() =>
      "Quote [$fieldEntityId: $id, $fieldQuoteText: $text, $fieldQuoteAuthorId: $authorId, $fieldQuoteBookId: $bookId, $fieldEntityModifiedUtc: $modifiedUtc, $fieldEntityCreatedUtc: $createdUtc]";
}

class QuoteEvent extends Event<QuoteDocument> implements EntityDocument {
  QuoteEvent(
    super.id,
    super.operation,
    super.quote,
    super.modified,
    super.created,
  );

  QuoteEvent.operation(QuoteDocument quote, String operation) : super(const Uuid().v4(), operation, quote, nowUtc(), nowUtc());

  QuoteEvent.create(QuoteDocument quote) : this.operation(quote, Event.created);

  QuoteEvent.update(QuoteDocument quote) : this.operation(quote, Event.modified);

  QuoteEvent.delete(QuoteDocument quote) : this.operation(quote, Event.deleted);

  QuoteEvent.fromJson(Map<String, dynamic> json)
      : super(
          json[fieldEntityId],
          json[operationLabel],
          QuoteDocument.fromJson(json[entityLabel]),
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
  String getId() => id;

  @override
  String toString() =>
      "QuoteEvent [$fieldEntityId: $id, $operationLabel: $operation, $fieldEntityModifiedUtc: $modifiedUtc, $fieldEntityCreatedUtc: $createdUtc, $entityLabel: ${entity.toString()}]";

  @override
  Map toSave() => toJson();

  @override
  Map toUpdate() => throw EventModificationException();
}
