import 'package:uuid/uuid.dart';

import '../common/model.dart';
import '../../infrastructure/elasticsearch/document.dart';

var quoteTextLabel = "text";
var quoteAuthorIdLabel = "authorId";
var quoteBookIdLabel = "bookId";

class Quote extends Entity with Document {
  String text, authorId, bookId;

  Quote(String id, this.text, this.authorId, this.bookId, DateTime modifiedUtc, DateTime createdUtc)
      : super(id, modifiedUtc, createdUtc);

  Quote.create(this.text, this.authorId, this.bookId) : super.create();

  Quote.update(String id, this.text, this.authorId, this.bookId)
      : super(id, DateTime.now().toUtc(), DateTime.now().toUtc());

  Quote.fromJson(Map<String, dynamic> json)
      : this(json[idLabel], json[quoteTextLabel], json[quoteAuthorIdLabel], json[quoteBookIdLabel],
            DateTime.parse(json[modifiedUtcLabel]), DateTime.parse(json[createdUtcLabel]));

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
      "Quote [$idLabel: $id, $quoteTextLabel: $text, $quoteAuthorIdLabel: $authorId, $quoteBookIdLabel: $bookId, " +
      "$modifiedUtcLabel: $modifiedUtc, $createdUtcLabel: $createdUtc]";
}

class QuoteEvent extends Event<Quote> with Document {
  QuoteEvent(String id, String operation, Quote quote, DateTime modified, DateTime created)
      : super(id, operation, quote, modified, created);

  QuoteEvent.operation(Quote quote, String operation)
      : super(Uuid().v4(), operation, quote, DateTime.now().toUtc(), DateTime.now().toUtc());

  QuoteEvent.create(Quote quote) : this.operation(quote, Event.created);

  QuoteEvent.update(Quote quote) : this.operation(quote, Event.modified);

  QuoteEvent.delete(Quote quote) : this.operation(quote, Event.deleted);

  QuoteEvent.fromJson(Map<String, dynamic> json)
      : super(json[idLabel], json[operationLabel], Quote.fromJson(json[entityLabel]),
            DateTime.parse(json[modifiedUtcLabel]), DateTime.parse(json[createdUtcLabel]));
  @override
  String getId() => this.id;

  @override
  String toString() =>
      "QuoteEvent [$idLabel: $id, $operationLabel: $operation, $modifiedUtcLabel: $modifiedUtc, $createdUtcLabel: $createdUtc, " +
      "$entityLabel: ${entity.toString()}]";
}

class ListEventsByQuoteRequest {
  String authorId, bookId, quoteId;
  late PageRequest pageRequest;

  ListEventsByQuoteRequest(this.authorId, this.bookId, this.quoteId, int offset, int limit) {
    pageRequest = PageRequest(limit, offset);
  }

  @override
  String toString() =>
      "ListEventsByQuoteRequest [authorId: $authorId, bookId: $bookId, " +
      "quoteId: $quoteId, pageRequest: $pageRequest]";
}

class ListQuotesFromBookRequest {
  String authorId, bookId;
  late PageRequest pageRequest;

  ListQuotesFromBookRequest(this.authorId, this.bookId, int offset, int limit) {
    pageRequest = PageRequest(limit, offset);
  }

  @override
  String toString() =>
      "ListQuotesFromBookRequest [authorId: $authorId, bookId: $bookId, " + "pageRequest: $pageRequest]";
}
