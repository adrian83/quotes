import 'dart:async';

import '../common/model.dart';
import '../common/repository.dart';
import 'model.dart';

import '../../common/function.dart';

import '../../infrastructure/elasticsearch/search.dart';
import '../../infrastructure/elasticsearch/store.dart';

Decoder<Quote> quoteDecoder = (Map<String, dynamic> json) => Quote.fromJson(json);

class QuoteRepository extends Repository<Quote> {
  QuoteRepository(ESStore<Quote> store) : super(store, quoteDecoder);

  Future<Page<Quote>> findBookQuotes(ListQuotesFromBookRequest request) {
    var query = MatchQuery(quoteBookIdLabel, request.bookId); // TODO: better query

    return this.findDocuments(query, request.pageRequest);
  }

  Future<Page<Quote>> findQuotes(SearchEntityRequest request) {
    var phrase = request.searchPhrase ?? "";
    var query = WildcardQuery(quoteTextLabel, phrase); // TODO: better query

    return this.findDocuments(query, request.pageRequest);
  }

  Future<void> deleteByAuthor(String authorId) {
    var query = JustQuery(MatchQuery(quoteAuthorIdLabel, authorId)); // TODO: better query
    return this.deleteDocuments(query);
  }
  // => deleteAll(deleteAuthorQuotesStmt, {"authorId": authorId});

  Future<void> deleteByBook(String bookId) {
    var query = JustQuery(MatchQuery(quoteBookIdLabel, bookId)); // TODO: better query
    return this.deleteDocuments(query);
  }
}

Decoder<QuoteEvent> quoteEventDecoder = (Map<String, dynamic> json) => QuoteEvent.fromJson(json);

class QuoteEventRepository extends Repository<QuoteEvent> {
  String _authorIdProp = "$entityLabel.$quoteAuthorIdLabel";
  String _bookIdProp = "$entityLabel.$quoteBookIdLabel";
  String _quoteIdProp = "$entityLabel.$idLabel";

  QuoteEventRepository(ESStore<QuoteEvent> store) : super(store, quoteEventDecoder);

  Future<void> saveQuote(Quote quote) {
    return this.save(QuoteEvent.create(quote));
  }

  Future<void> updateQuote(Quote quote) {
    return this.save(QuoteEvent.update(quote));
  }

  Future<void> deleteQuote(String quoteId) {
    var idQuery = MatchQuery("$entityLabel.$idLabel", quoteId);
    var sorting = SortElement.desc(modifiedUtcLabel);

    return super
        .findDocuments(idQuery, PageRequest(1, 0), sorting: sorting)
        .then((page) => this.save(QuoteEvent.delete(page.elements[0].entity)));
  }

  Future<void> deleteByAuthor(String authorId) {
    var authorIdQ = MatchQuery(_authorIdProp, authorId);
    logger.info("delete QuoteEvents by author: $authorId");
    return super
        .findDocuments(authorIdQ, PageRequest(1000, 0))
        .then((page) {
          logger.info("page of QuoteEvents to be deleted: ${page.toString()}");
          return page;
        })
        .then((page) => groupByEntityId(page))
        .then((map) => newest(map))
        .then((newestQuotes) => Future.wait(newestQuotes.map((book) => deleteQuote(book.id))));
  }

  Future<void> deleteByBook(String bookId) {
    var bookIdQ = MatchQuery(_bookIdProp, bookId);
    logger.info("delete QuoteEvents by book: $bookId");
    return super
        .findDocuments(bookIdQ, PageRequest(1000, 0))
        .then((page) {
          logger.info("page of QuoteEvents to be deleted: ${page.toString()}");
          return page;
        })
        .then((page) => groupByEntityId(page))
        .then((map) => newest(map))
        .then((newestQuotes) => Future.wait(newestQuotes.map((book) => deleteQuote(book.id))));
  }

  Map<String, List<QuoteEvent>> groupByEntityId(Page<QuoteEvent> page) {
    return groupBy(page.elements, (event) => event.entity.id);
  }

  List<Quote> newest(Map<String, List<QuoteEvent>> data) {
    return data
        .map((key, value) {
          value.sort((a, b) => a.entity.createdUtc.compareTo(b.entity.createdUtc));
          return MapEntry(key, value[0].entity);
        })
        .values
        .toList();
  }

  Future<Page<QuoteEvent>> listEvents(ListEventsByQuoteRequest request) {
    var query = MatchQuery(_quoteIdProp, request.quoteId);
    var sorting = SortElement.asc(createdUtcLabel);
    return super.findDocuments(query, request.pageRequest, sorting: sorting);
  }
}
