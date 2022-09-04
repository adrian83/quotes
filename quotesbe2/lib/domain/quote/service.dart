import 'dart:async';

import 'package:logging/logging.dart';
import 'package:uuid/uuid.dart';

import 'package:quotesbe2/domain/common/model.dart';
import 'package:quotesbe2/domain/quote/model.dart';
import 'package:quotesbe2/domain/quote/repository.dart';

class NewQuoteCommand {
  final String authorId, bookId, text;

  NewQuoteCommand(this.authorId, this.bookId, this.text);

  Quote toQuote() => Quote(
        const Uuid().v4(),
        text,
        authorId,
        bookId,
        DateTime.now(),
        DateTime.now(),
      );
}

class UpdateQuoteCommand {
  final String quoteId, bookId, authorId, text;

  UpdateQuoteCommand(this.authorId, this.bookId, this.quoteId, this.text);

  Quote toQuote() => Quote(
        quoteId,
        text,
        authorId,
        bookId,
        DateTime.now(),
        DateTime.now(),
      );
}

class FindQuoteQuery {
  final String authorId, bookId, quoteId;

  FindQuoteQuery(this.authorId, this.bookId, this.quoteId);
}

class DeleteQuoteCommand {
  final String authorId, bookId, quoteId;

  DeleteQuoteCommand(this.authorId, this.bookId, this.quoteId);
}

class QuoteService {
  final Logger _logger = Logger('QuoteService');

  final QuoteRepository _quotesRepository;
  final QuoteEventRepository _quoteEventRepository;

  QuoteService(this._quotesRepository, this._quoteEventRepository);

  Future<Quote> save(NewQuoteCommand command) async {
    var quote = command.toQuote();
    _logger.info("save quote: $quote");
    await _quotesRepository.save(quote);
    _logger.info("store quote event (create) for quote: $quote");
    await _quoteEventRepository.storeSaveQuoteEvent(quote);
    return quote;
  }

  Future<Quote> find(FindQuoteQuery query) async {
    _logger.info("find quote by id: ${query.quoteId}");
    return await _quotesRepository.find(query.quoteId);
  }

  Future<Quote> update(UpdateQuoteCommand command) async {
    var quote = command.toQuote();
    _logger.info("update quote: $quote");
    await _quotesRepository.update(quote);
    _logger.info("store quote event (update) for quote: $quote");
    await _quoteEventRepository.storeUpdateQuoteEvent(quote);
    return quote;
  }

  Future<void> delete(DeleteQuoteCommand command) async {
    _logger.info("delete quote with id: ${command.quoteId}");
    await _quotesRepository.delete(command.quoteId);
    _logger.info(
        "store quote event (delete) for quote with id: ${command.quoteId}");
    await _quoteEventRepository.storeDeleteQuoteEventByQuoteId(command.quoteId);
    return;
  }

  Future<Page<Quote>> findBookQuotes(ListQuotesFromBookRequest request) =>
      Future.value(request)
          .then((_) => _logger.info("find book quotes by request: $request"))
          .then((value) => _quotesRepository.findBookQuotes(request));

  Future<Page<Quote>> findQuotes(SearchQuery request) => Future.value(request)
      .then((_) => _logger.info("find quotes by request: $request"))
      .then((_) => _quotesRepository.findQuotes(request));

  Future<Page<QuoteEvent>> listEvents(ListEventsByQuoteRequest request) =>
      Future.value(request)
          .then((_) => _logger.info("find quote events by request: $request"))
          .then((_) => _quoteEventRepository.findQuoteEvents(request));

  Future<void> deleteByAuthor(String authorId) => Future.value(authorId)
      .then((_) => _logger.info("delete quotes by author with id: $authorId"))
      .then((_) => _quotesRepository.deleteByAuthor(authorId))
      .then((_) => _logger
          .info("store quote events (delete) for author with id: $authorId"))
      .then((_) => _quoteEventRepository.deleteByAuthor(authorId));
}
