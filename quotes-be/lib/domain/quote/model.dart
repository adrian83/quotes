import 'package:uuid/uuid.dart';

import '../../infrastructure/elasticsearch/document.dart';
import '../common/model.dart';


var idLabel = 'id';
var textLabel = "text";
var authorIdLabel = "authorId";
var bookIdLabel = "bookId";
var eventIdLabel = 'eventId';
var operationLabel = 'operation';
var createdUtcLabel = 'createdUtc';
var descriptionLabel = 'description';
var modifiedUtcLabel = 'modifiedUtc';

class Quote extends Entity with Document {
  String text, authorId, bookId;

  Quote(String id, this.text, this.authorId, this.bookId, DateTime modifiedUtc, DateTime createdUtc) : super(id, modifiedUtc, createdUtc);

  Quote.create(this.text, this.authorId, this.bookId) : super(Uuid().v4(), DateTime.now().toUtc(), DateTime.now().toUtc());

  Quote.update(String id, this.text, this.authorId, this.bookId) : super(id, DateTime.now().toUtc(), DateTime.now().toUtc());

  Quote.fromJson(Map<String, dynamic> json)
      : this(json[idLabel], json[textLabel], json[authorIdLabel], json[bookIdLabel], DateTime.parse(json[modifiedUtcF]), DateTime.parse(json[createdUtcF]));

  String getId() => id;

  Map toJson() => super.toJson()
    ..addAll({
      textLabel: text,
      authorIdLabel: authorId,
      bookIdLabel: bookId,
    });

  String toString() => "Quote [$idLabel: $id, $textLabel: $text, $authorIdLabel: $authorId, $bookIdLabel: $bookId, $modifiedUtcLabel: $modifiedUtc, $createdUtcLabel: $createdUtc]";
}



class QuoteEvent extends Event<Quote> with Document {
  QuoteEvent(String id, String operation, Quote quote, DateTime modified, DateTime created) : super(id, operation, quote, modified, created);

  QuoteEvent.create(Quote quote) : super(Uuid().v4(), Event.created, quote, DateTime.now().toUtc(), DateTime.now().toUtc());

  QuoteEvent.update(Quote quote) : super(Uuid().v4(), Event.modified, quote, DateTime.now().toUtc(), DateTime.now().toUtc());

  QuoteEvent.delete(Quote quote) : super(Uuid().v4(), Event.deleted, quote, DateTime.now().toUtc(), DateTime.now().toUtc());

  QuoteEvent.fromJson(Map<String, dynamic> json)
      : super(json[idF], json[operationF], Quote.fromJson(json[entityF]), DateTime.parse(json[modifiedUtcLabel]), DateTime.parse(json[createdUtcLabel]));

  String getId() => this.id;

  String toString() =>
      "QuoteEvent [$idLabel: $id, $operationLabel: $operation, $modifiedUtcLabel: $modifiedUtc, $createdUtcLabel: $createdUtc quote: ${entity.toString()}]";
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
