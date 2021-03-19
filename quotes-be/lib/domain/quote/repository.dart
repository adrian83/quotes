import 'dart:async';

import 'package:logging/logging.dart';

import 'model.dart';
import '../common/model.dart';
import '../common/repository.dart';
import '../../infrastructure/elasticsearch/search.dart';
import '../../infrastructure/elasticsearch/store.dart';

Decoder<Quote> quoteDecoder = (Map<String, dynamic> json) => Quote.fromJson(json);

class QuoteRepository extends Repository<Quote> {
  final Logger _logger = Logger('QuoteRepository');

  QuoteRepository(ESStore<Quote> store) : super(store, quoteDecoder);

  Future<Page<Quote>> findBookQuotes(ListQuotesFromBookRequest request) => Future.value(request)
      .then((_) => _logger.info("find quotes from book by request: $request"))
      .then((_) => MatchQuery(quoteBookIdLabel, request.bookId))
      .then((query) => this.findDocuments(query, request.pageRequest, sorting: SortElement.desc(modifiedUtcLabel)));

  Future<Page<Quote>> findQuotes(SearchEntityRequest request) => Future.value(request)
      .then((_) => _logger.info("find quotes by request: $request"))
      .then((_) => WildcardQuery(quoteTextLabel, request.searchPhrase ?? ""))
      .then((query) => this.findDocuments(query, request.pageRequest, sorting: SortElement.desc(modifiedUtcLabel)));

  Future<void> deleteByAuthor(String authorId) => Future.value(authorId)
      .then((_) => _logger.info("delete books by author with id: $authorId"))
      .then((_) => JustQuery(MatchQuery(quoteAuthorIdLabel, authorId)))
      .then((query) => this.deleteDocuments(query));

  Future<void> deleteByBook(String bookId) => Future.value(bookId)
      .then((_) => _logger.info("delete quotes by book with id: $bookId"))
      .then((_) => JustQuery(MatchQuery(quoteBookIdLabel, bookId)))
      .then((query) => this.deleteDocuments(query));
}

Decoder<QuoteEvent> quoteEventDecoder = (Map<String, dynamic> json) => QuoteEvent.fromJson(json);

class QuoteEventRepository extends Repository<QuoteEvent> {
  final Logger _logger = Logger('QuoteRepository');

  String _authorIdProp = "$entityLabel.$quoteAuthorIdLabel";
  String _bookIdProp = "$entityLabel.$quoteBookIdLabel";
  String _quoteIdProp = "$entityLabel.$idLabel";

  QuoteEventRepository(ESStore<QuoteEvent> store) : super(store, quoteEventDecoder);

  Future<void> storeSaveQuoteEvent(Quote quote) => Future.value(quote)
      .then((_) => _logger.info("save quote event (save) for quote: $quote"))
      .then((_) => this.save(QuoteEvent.create(quote)));

  Future<void> storeUpdateQuoteEvent(Quote quote) => Future.value(quote)
      .then((_) => _logger.info("save quote event (update) for book: $quote"))
      .then((_) => this.save(QuoteEvent.update(quote)));

  Future<void> storeDeleteQuoteEvent(Quote quote) => Future.value(quote)
      .then((_) => _logger.info("save quote event (delete) for book: $quote"))
      .then((_) => this.save(QuoteEvent.delete(quote)));

  Future<void> storeDeleteQuoteEventByQuoteId(String quoteId) => Future.value(quoteId)
      .then((_) => _logger.info("save quote event (delete) for quote with id: $quoteId"))
      .then((_) => MatchQuery(_quoteIdProp, quoteId))
      .then((query) => super.findDocuments(query, PageRequest.first(), sorting: SortElement.desc(modifiedUtcLabel)))
      .then((page) => storeDeleteQuoteEvent(page.elements[0].entity));

  Future<void> deleteByAuthor(String authorId) => Future.value(authorId)
      .then((_) => _logger.info("save quote events (delete) for quotes created by author with id: $authorId"))
      .then((_) => MatchQuery(_authorIdProp, authorId))
      .then((query) => super.findDocuments(query, PageRequest(1000, 0)))
      .then((page) => this.newestEntities(page))
      .then((newestQuotes) => Future.wait(newestQuotes.map((quote) => storeDeleteQuoteEvent(quote))));

  Future<void> deleteByBook(String bookId) => Future.value(bookId)
      .then((_) => _logger.info("save quote events (delete) for quotes from book with id: $bookId"))
      .then((_) => MatchQuery(_bookIdProp, bookId))
      .then((query) => super.findDocuments(query, PageRequest(1000, 0)))
      .then((page) => this.newestEntities(page))
      .then((newestQuotes) => Future.wait(newestQuotes.map((quote) => storeDeleteQuoteEvent(quote))));

  Future<Page<QuoteEvent>> findQuoteEvents(ListEventsByQuoteRequest request) => Future.value(request)
      .then((_) => _logger.info("find quote events by request: $request"))
      .then((_) => MatchQuery(_quoteIdProp, request.quoteId))
      .then((query) => super.findDocuments(query, request.pageRequest, sorting: SortElement.asc(createdUtcLabel)));
}
