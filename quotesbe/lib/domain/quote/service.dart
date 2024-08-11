import 'dart:async';

import 'package:logging/logging.dart';

import 'package:quotesbe/domain/common/model.dart';
import 'package:quotesbe/domain/quote/model/command.dart';
import 'package:quotesbe/domain/quote/model/entity.dart';
import 'package:quotesbe/domain/quote/model/query.dart';
import 'package:quotesbe/domain/quote/repository.dart';
import 'package:quotes_common/domain/quote.dart';
import 'package:quotes_common/domain/page.dart';

class QuoteService {
  final Logger _logger = Logger('QuoteService');

  final QuoteRepository _quotesRepository;
  final QuoteEventRepository _quoteEventRepository;

  QuoteService(this._quotesRepository, this._quoteEventRepository);

  Future<Quote> save(NewQuoteCommand command) async {
    var quote = command.toQuote();
    var quoteDocument = QuoteDocument.fromModel(quote);
    _logger.info("save quote: $quote");
    await _quotesRepository.save(quoteDocument);
    _logger.info("store quote event (create) for quote: $quote");
    await _quoteEventRepository.storeSaveQuoteEvent(quoteDocument);
    return quote;
  }

  Future<Quote> find(FindQuoteQuery query) async {
    _logger.info("find quote by query: $query");
    return await _quotesRepository.find(query.quoteId);
  }

  Future<Quote> update(UpdateQuoteCommand command) async {
    var quote = command.toQuote();
    var quoteDocument = QuoteDocument.fromModel(quote);
    _logger.info("update quote: $quote");
    await _quotesRepository.update(quoteDocument);
    _logger.info("store quote event (update) for quote: $quote");
    await _quoteEventRepository.storeUpdateQuoteEvent(quoteDocument);
    return quote;
  }

  Future<void> delete(DeleteQuoteCommand command) async {
    _logger.info("delete quote by command: $command");
    await _quotesRepository.delete(command.quoteId);
    _logger.info("store quote event (delete) by command: $command");
    await _quoteEventRepository.storeDeleteQuoteEventByQuoteId(command.quoteId);
    return;
  }

  Future<Page<Quote>> findBookQuotes(ListQuotesFromBookQuery query) async {
    _logger.info("find book quotes by query: $query");
    return await _quotesRepository.findBookQuotes(query);
  }

  Future<Page<Quote>> findQuotes(SearchQuery query) async {
    _logger.info("find quotes by query: $query");
    return await _quotesRepository.findQuotes(query);
  }

  Future<Page<QuoteEvent>> listEvents(ListEventsByQuoteQuery query) async {
    _logger.info("find quote events by query: $query");
    return await _quoteEventRepository.findQuoteEvents(query);
  }

  Future<void> deleteByAuthor(String authorId) async {
    _logger.info("delete quotes by author with id: $authorId");
    await _quotesRepository.deleteByAuthor(authorId);
    _logger.info("store quote events (delete) for author with id: $authorId");
    await _quoteEventRepository.deleteByAuthor(authorId);
    return;
  }
}
