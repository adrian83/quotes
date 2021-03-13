import 'package:uuid/uuid.dart';

import '../../infrastructure/elasticsearch/document.dart';
import '../common/model.dart';

var quoteTextLabel = "text";
var quoteAuthorIdLabel = "authorId";
var quoteBookIdLabel = "bookId";

class Quote extends Entity with Document {
  String text, authorId, bookId;

  Quote(String id, this.text, this.authorId, this.bookId, DateTime modifiedUtc, DateTime createdUtc)
      : super(id, modifiedUtc, createdUtc);

  Quote.create(this.text, this.authorId, this.bookId)
      : super(Uuid().v4(), DateTime.now().toUtc(), DateTime.now().toUtc());

  Quote.update(String id, this.text, this.authorId, this.bookId)
      : super(id, DateTime.now().toUtc(), DateTime.now().toUtc());

  Quote.fromJson(Map<String, dynamic> json)
      : this(json[idLabel], json[quoteTextLabel], json[quoteAuthorIdLabel], json[quoteBookIdLabel],
            DateTime.parse(json[modifiedUtcLabel]), DateTime.parse(json[createdUtcLabel]));

  String getId() => id;

  Map toJson() => super.toJson()
    ..addAll({
      quoteTextLabel: text,
      quoteAuthorIdLabel: authorId,
      quoteBookIdLabel: bookId,
    });

  String toString() =>
      "Quote [$idLabel: $id, $quoteTextLabel: $text, $quoteAuthorIdLabel: $authorId, $quoteBookIdLabel: $bookId, $modifiedUtcLabel: $modifiedUtc, $createdUtcLabel: $createdUtc]";
}

class QuoteEvent extends Event<Quote> with Document {
  QuoteEvent(String id, String operation, Quote quote, DateTime modified, DateTime created)
      : super(id, operation, quote, modified, created);

  QuoteEvent.create(Quote quote)
      : super(Uuid().v4(), Event.created, quote, DateTime.now().toUtc(), DateTime.now().toUtc());

  QuoteEvent.update(Quote quote)
      : super(Uuid().v4(), Event.modified, quote, DateTime.now().toUtc(), DateTime.now().toUtc());

  QuoteEvent.delete(Quote quote)
      : super(Uuid().v4(), Event.deleted, quote, DateTime.now().toUtc(), DateTime.now().toUtc());

  QuoteEvent.fromJson(Map<String, dynamic> json)
      : super(json[idLabel], json[operationLabel], Quote.fromJson(json[entityLabel]),
            DateTime.parse(json[modifiedUtcLabel]), DateTime.parse(json[createdUtcLabel]));

  String getId() => this.id;

  String toString() =>
      "QuoteEvent [$idLabel: $id, $operationLabel: $operation, $modifiedUtcLabel: $modifiedUtc, $createdUtcLabel: $createdUtc, $entityLabel: ${entity.toString()}]";
}

class ListEventsByQuoteRequest {
  String authorId, bookId, quoteId;
  late PageRequest pageRequest;

  ListEventsByQuoteRequest(this.authorId, this.bookId, this.quoteId, int offset, int limit) {
    pageRequest = PageRequest(limit, offset);
  }
}

class ListQuotesFromBookRequest {
  String authorId, bookId;
  late PageRequest pageRequest;

  ListQuotesFromBookRequest(this.authorId, this.bookId, int offset, int limit) {
    pageRequest = PageRequest(limit, offset);
  }
}
