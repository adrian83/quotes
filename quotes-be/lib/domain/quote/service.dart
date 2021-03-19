import 'dart:async';

import 'package:logging/logging.dart';

import 'model.dart';
import 'repository.dart';
import '../common/model.dart';
import '../common/exception.dart';
import '../../common/function.dart';

class QuoteService {
  final Logger _logger = Logger('QuoteService');

  QuoteRepository _quotesRepository;
  QuoteEventRepository _quoteEventRepository;

  QuoteService(this._quotesRepository, this._quoteEventRepository);

  Future<Quote> save(Quote quote) => Future.value(quote)
      .then((_) => _logger.info("save quote: $quote"))
      .then((_) => _quotesRepository.save(quote))
      .then((_) => _logger.info("store quote event (create) for quote: $quote"))
      .then((_) => pass(quote, (q) => _quoteEventRepository.storeSaveQuoteEvent(quote)))
      .catchError(errorHandler);

  Future<Quote> find(String quoteId) => Future.value(quoteId)
      .then((_) => _logger.info("find quote by id: $quoteId"))
      .then((_) => _quotesRepository.find(quoteId))
      .catchError(errorHandler);

  Future<Quote> update(Quote quote) => Future.value(quote)
      .then((_) => _logger.info("update quote: $quote"))
      .then((_) => _quotesRepository.update(quote))
      .then((_) => _logger.info("store quote event (update) for quote: $quote"))
      .then((_) => pass(quote, (q) => _quoteEventRepository.storeUpdateQuoteEvent(quote)))
      .catchError(errorHandler);

  Future<void> delete(String quoteId) => Future.value(quoteId)
      .then((_) => _logger.info("delete quote with id: $quoteId"))
      .then((_) => _quotesRepository.delete(quoteId))
      .then((_) => _logger.info("store quote event (delete) for quote with id: $quoteId"))
      .then((_) => _quoteEventRepository.storeDeleteQuoteEventByQuoteId(quoteId))
      .catchError(errorHandler);

  Future<Page<Quote>> findBookQuotes(ListQuotesFromBookRequest request) => Future.value(request)
      .then((_) => _logger.info("find book quotes by request: $request"))
      .then((value) => _quotesRepository.findBookQuotes(request))
      .catchError(errorHandler);

  Future<Page<Quote>> findQuotes(SearchEntityRequest request) => Future.value(request)
      .then((_) => _logger.info("find quotes by request: $request"))
      .then((_) => _quotesRepository.findQuotes(request))
      .catchError(errorHandler);

  Future<Page<QuoteEvent>> listEvents(ListEventsByQuoteRequest request) => Future.value(request)
      .then((_) => _logger.info("find quote events by request: $request"))
      .then((_) => _quoteEventRepository.findQuoteEvents(request))
      .catchError(errorHandler);

  Future<void> deleteByAuthor(String authorId) => Future.value(authorId)
      .then((_) => _logger.info("delete quotes by author with id: $authorId"))
      .then((_) => _quotesRepository.deleteByAuthor(authorId))
      .then((_) => _logger.info("store quote events (delete) for author with id: $authorId"))
      .then((_) => _quoteEventRepository.deleteByAuthor(authorId))
      .catchError(errorHandler);
}
