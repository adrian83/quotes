import 'dart:async';

import 'package:logging/logging.dart';

import 'package:quotesbe/domain/common/model.dart';
import 'package:quotesbe/domain/quote/model/entity.dart';
import 'package:quotesbe/domain/quote/model/query.dart';
import 'package:quotesbe/domain/common/repository.dart';
import 'package:quotesbe/storage/elasticsearch/store.dart';
import 'package:quotesbe/storage/elasticsearch/search.dart';
import 'package:quotes_common/domain/entity.dart';
import 'package:quotes_common/domain/quote.dart';
import 'package:quotes_common/domain/page.dart';

Decoder<QuoteDocument> quoteDecoder = (Map<String, dynamic> json) => QuoteDocument.fromJson(json);

class QuoteRepository extends Repository<QuoteDocument> {
  final Logger _logger = Logger('QuoteRepository');

  QuoteRepository(ESStore<QuoteDocument> store) : super(store, quoteDecoder);

  Future<Page<Quote>> findBookQuotes(ListQuotesFromBookQuery query) async {
    _logger.info("find quotes from book by query: $query");
    var matchQuery = MatchQuery(fieldQuoteBookId, query.bookId);
    return await findDocuments(
      matchQuery,
      query.pageRequest,
      sorting: sortingByModifiedTimeDesc,
    );
  }

  Future<Page<Quote>> findQuotes(SearchQuery request) async {
    _logger.info("find quotes by request: $request");
    var searchPhrase = request.searchPhrase ?? "";
    var wildcardQuery = WildcardQuery(fieldQuoteText, searchPhrase);
    return await findDocuments(
      wildcardQuery,
      request.pageRequest,
      sorting: sortingByModifiedTimeDesc,
    );
  }

  Future<void> deleteByAuthor(String authorId) async {
    _logger.info("delete books by author with id: $authorId");
    var query = JustQuery(MatchQuery(fieldQuoteAuthorId, authorId));
    await deleteDocuments(query);
    return;
  }

  Future<void> deleteByBook(String bookId) async {
    _logger.info("delete quotes by book with id: $bookId");
    var query = JustQuery(MatchQuery(fieldQuoteBookId, bookId));
    await deleteDocuments(query);
    return;
  }
}

Decoder<QuoteEvent> quoteEventDecoder = (Map<String, dynamic> json) => QuoteEvent.fromJson(json);

class QuoteEventRepository extends Repository<QuoteEvent> {
  final Logger _logger = Logger('QuoteRepository');

  final String _authorIdProp = "$entityLabel.$fieldQuoteAuthorId";
  final String _bookIdProp = "$entityLabel.$fieldQuoteBookId";
  final String _quoteIdProp = "$entityLabel.$fieldEntityId";

  QuoteEventRepository(ESStore<QuoteEvent> store) : super(store, quoteEventDecoder);

  Future<void> storeSaveQuoteEvent(QuoteDocument quote) async {
    _logger.info("save quote event (save) for quote: $quote");
    await save(QuoteEvent.create(quote));
    return;
  }

  Future<void> storeUpdateQuoteEvent(QuoteDocument quote) async {
    _logger.info("save quote event (update) for book: $quote");
    await save(QuoteEvent.update(quote));
    return;
  }

  Future<void> storeDeleteQuoteEvent(QuoteDocument quote) async {
    _logger.info("save quote event (delete) for book: $quote");
    await save(QuoteEvent.delete(quote));
    return;
  }

  Future<void> storeDeleteQuoteEventByQuoteId(String quoteId) async {
    _logger.info("save quote event (delete) for quote with id: $quoteId");
    var matchQuery = MatchQuery(_quoteIdProp, quoteId);
    var page = await super.findDocuments(
      matchQuery,
      PageRequest.first(),
      sorting: SortElement.desc(fieldEntityModifiedUtc),
    );
    return storeDeleteQuoteEvent(page.elements.first.entity);
  }

  Future<void> deleteByAuthor(String authorId) async {
    _logger.info("save events (delete) for quotes created by author: $authorId");
    var matchQuery = MatchQuery(_authorIdProp, authorId);
    var quoteEvents = await super.findAllDocuments(matchQuery);
    var newestQuotes = newestEntities(quoteEvents);
    Future.wait(newestQuotes.map((quote) => storeDeleteQuoteEvent(quote)));
    return;
  }

  Future<void> deleteByBook(String bookId) async {
    _logger.info("save events (delete) for quotes from book: $bookId");
    var matchQuery = MatchQuery(_bookIdProp, bookId);
    var quoteEvents = await super.findAllDocuments(matchQuery);
    var newestQuotes = newestEntities(quoteEvents);
    Future.wait(newestQuotes.map((quote) => storeDeleteQuoteEvent(quote)));
    return;
  }

  Future<Page<QuoteEvent>> findQuoteEvents(ListEventsByQuoteQuery query) async {
    _logger.info("find events by request: $query");
    var matchQuery = MatchQuery(_quoteIdProp, query.quoteId);
    return await super.findDocuments(
      matchQuery,
      query.pageRequest,
      sorting: SortElement.asc(fieldEntityCreatedUtc),
    );
  }
}
