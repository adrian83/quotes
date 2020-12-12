import 'package:uuid/uuid.dart';

import '../../infrastructure/elasticsearch/document.dart';
import '../common/model.dart';

const textF = "text";
const authorIdF = "authorId";
const bookIdF = "bookId";

class Quote extends Entity {
  String text, authorId, bookId;

  Quote(String id, this.text, this.authorId, this.bookId, DateTime modifiedUtc, DateTime createdUtc) : super(id, modifiedUtc, createdUtc);

  Quote.create(this.text, this.authorId, this.bookId) : super(Uuid().v4(), DateTime.now().toUtc(), DateTime.now().toUtc());

  Quote.update(String id, this.text, this.authorId, this.bookId) : super(id, DateTime.now().toUtc(), DateTime.now().toUtc());

  Quote.fromJson(Map<String, dynamic> json)
      : this(json[idF], json[textF], json[authorIdF], json[bookIdF], DateTime.parse(json[modifiedUtcF]), DateTime.parse(json[createdUtcF]));

  Quote.fromDB(List<dynamic> row)
      : this(row[0].toString().trim(), row[1].toString().trim(), row[2].toString().trim(), row[3].toString().trim(), row[4], row[5]);

  Map toJson() => super.toJson()
    ..addAll({
      textF: text,
      authorIdF: authorId,
      bookIdF: bookId,
    });

  String toString() => "Quote [$idF: $id, $textF: $text, $authorIdF: $authorId, $bookIdF: $bookId, $modifiedUtcF: $modifiedUtc, $createdUtcF: $createdUtc]";
}

class QuoteEvent extends ESDocument {
  Quote quote;

  QuoteEvent(String docId, String operation, this.quote) : super(docId, operation);

  QuoteEvent.created(String docId, Quote quote) : this(docId, ESDocument.created, quote);

  QuoteEvent.modified(String docId, Quote quote) : this(docId, ESDocument.modified, quote);

  QuoteEvent.deleted(String docId, Quote quote) : this(docId, ESDocument.deleted, quote);

  QuoteEvent.fromJson(Map<String, dynamic> json) : this(json['docId'], json['operation'], Quote.fromJson(json));

  Map toJson() => super.toJson()..addAll(quote.toJson());

  String toString() => "QuoteEvent [eventId: $eventId, operation: $operation, modifiedUtc: $modifiedUtc, quote: $quote]";
}



class SearchQuoteRequest{ 
  String? searchPhrase;
  late PageRequest pageRequest;

  SearchQuoteRequest(this.searchPhrase, int offset, int limit){
pageRequest = PageRequest(limit, offset);
  }
}

class ListEventsByQuoteRequest {
  String authorId, bookId, quoteId;
    late PageRequest pageRequest;

      ListEventsByQuoteRequest(this.authorId, this.bookId, this.quoteId, int offset, int limit){
pageRequest = PageRequest(limit, offset);
  }
}

class ListQuotesFromBookRequest {
    String authorId, bookId;
    late PageRequest pageRequest;

      ListQuotesFromBookRequest(this.authorId, this.bookId, int offset, int limit){
pageRequest = PageRequest(limit, offset);
  }
}