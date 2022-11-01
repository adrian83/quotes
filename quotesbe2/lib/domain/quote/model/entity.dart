import 'package:uuid/uuid.dart';

import 'package:quotesbe2/domain/common/model.dart';

var quoteTextLabel = "text";
var quoteAuthorIdLabel = "authorId";
var quoteBookIdLabel = "bookId";

class Quote extends Entity {
  String text, authorId, bookId;

  Quote(
    String id,
    this.text,
    this.authorId,
    this.bookId,
    DateTime modifiedUtc,
    DateTime createdUtc,
  ) : super(id, modifiedUtc, createdUtc);

  Quote.create(this.text, this.authorId, this.bookId) : super.create();

  Quote.update(String id, this.text, this.authorId, this.bookId)
      : super(id, nowUtc(), nowUtc());

  Quote.fromJson(Map<String, dynamic> json)
      : this(
          json[idLabel],
          json[quoteTextLabel],
          json[quoteAuthorIdLabel],
          json[quoteBookIdLabel],
          DateTime.parse(json[modifiedUtcLabel]),
          DateTime.parse(json[createdUtcLabel]),
        );

  @override
  String getId() => id;

  @override
  Map<dynamic, dynamic> toSave() => toJson();

  @override
  Map<dynamic, dynamic> toUpdate() => toJson()..remove(createdUtcLabel);

  @override
  Map<dynamic, dynamic> toJson() => super.toJson()
    ..addAll({
      quoteTextLabel: text,
      quoteAuthorIdLabel: authorId,
      quoteBookIdLabel: bookId,
    });

  @override
  String toString() =>
      "Quote [$idLabel: $id, $quoteTextLabel: $text, $quoteAuthorIdLabel: $authorId, $quoteBookIdLabel: $bookId, $modifiedUtcLabel: $modifiedUtc, $createdUtcLabel: $createdUtc]";
}

class QuoteEvent extends Event<Quote> {
  QuoteEvent(
    String id,
    String operation,
    Quote quote,
    DateTime modified,
    DateTime created,
  ) : super(id, operation, quote, modified, created);

  QuoteEvent.operation(Quote quote, String operation)
      : super(const Uuid().v4(), operation, quote, nowUtc(), nowUtc());

  QuoteEvent.create(Quote quote) : this.operation(quote, Event.created);

  QuoteEvent.update(Quote quote) : this.operation(quote, Event.modified);

  QuoteEvent.delete(Quote quote) : this.operation(quote, Event.deleted);

  QuoteEvent.fromJson(Map<String, dynamic> json)
      : super(
          json[idLabel],
          json[operationLabel],
          Quote.fromJson(json[entityLabel]),
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
  String getId() => id;

  @override
  String toString() =>
      "QuoteEvent [$idLabel: $id, $operationLabel: $operation, $modifiedUtcLabel: $modifiedUtc, $createdUtcLabel: $createdUtc, $entityLabel: ${entity.toString()}]";
}




