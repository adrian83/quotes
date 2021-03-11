import 'dart:async';

import '../common/model.dart';
import '../common/repository.dart';
import 'model.dart';

import '../../infrastructure/elasticsearch/search.dart';
import '../../infrastructure/elasticsearch/store.dart';

Decoder<Quote> quoteDecoder = (Map<String, dynamic> json) => Quote.fromJson(json);

class QuoteRepository extends Repository<Quote> {
  QuoteRepository(ESStore<Quote> store) : super(store, quoteDecoder);

  Future<Page<Quote>> findBookQuotes(ListQuotesFromBookRequest request) {
    var query = MatchQuery("bookId", request.bookId); // TODO: better query

    return this.findDocuments(query, request.pageRequest);
  }

  Future<Page<Quote>> findQuotes(SearchEntityRequest request) {
    var phrase = request.searchPhrase ?? "";
    var query = WildcardQuery("text", phrase); // TODO: better query

    return this.findDocuments(query, request.pageRequest);
  }

  Future<void> deleteByAuthor(String authorId) {
    var query = MatchQuery("authorId", authorId); // TODO: better query
    return this.deleteDocuments(query);
  }
  // => deleteAll(deleteAuthorQuotesStmt, {"authorId": authorId});

  Future<void> deleteByBook(String bookId) {
    var query = MatchQuery("bookId", bookId); // TODO: better query
    return this.deleteDocuments(query);
  }
}


Decoder<QuoteEvent> quoteEventDecoder = (Map<String, dynamic> json) => QuoteEvent.fromJson(json);

class QuoteEventRepository extends Repository<QuoteEvent> {
  QuoteEventRepository(ESStore<QuoteEvent> store) : super(store, quoteEventDecoder);

  Future<void> saveQuote(Quote quote) {
    return this.save(QuoteEvent.create(quote));
  }
 
  Future<void> updateQuote(Quote quote) {
    return this.save(QuoteEvent.update(quote));
  }

    Future<void> deleteAuthor(String quoteId) {
    var idQuery = MatchQuery("entity.id", quoteId);
    var sorting = SortElement.desc(modifiedUtcF);

    return super.findDocuments(idQuery, PageRequest(1, 0), sorting:sorting)
    .then((page) => this.save(QuoteEvent.delete(page.elements[0].entity)));
  }

  Future<void> deleteByAuthor(String authorId) {
    var authorIdQ = MatchQuery("entity.authorId", authorId);
    return super.deleteDocuments(authorIdQ);
  }

  Future<void> deleteByBook(String bookId) {
    var bookIdQ = MatchQuery("entity.bookId", bookId);
    return super.deleteDocuments(bookIdQ);
  }

  Future<Page<QuoteEvent>> listEvents(ListEventsByQuoteRequest request) {
    var query = MatchQuery("entity.id", request.quoteId);
    return super.findDocuments(query, request.pageRequest);
  }


}
