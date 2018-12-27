import 'dart:async';

import 'model.dart';
import 'repository.dart';
import 'event.dart';

import '../common/model.dart';

class QuoteService {
  QuoteRepository _quotesRepository;
  QuoteEventRepository _quoteEventRepository;

  QuoteService(this._quotesRepository, this._quoteEventRepository);

  Future<Page<Quote>> findBookQuotes(String bookId, PageRequest request) =>
      _quotesRepository.findBookQuotes(bookId, request);

  Future<Page<Quote>> findQuotes(String searchPhrase, PageRequest request) =>
      _quotesRepository.findQuotes(searchPhrase, request);

  Future<Page<QuoteEvent>> listEvents(String authorId, String bookId,
          String quoteId, PageRequest request) =>
      _quoteEventRepository.listEvents(authorId, bookId, quoteId, request);

  Future<Quote> save(Quote quote) => _quotesRepository
      .save(quote.generateId())
      .then((quote) => _quoteEventRepository.save(quote));

  Future<Quote> update(Quote quote) => _quotesRepository
      .update(quote)
      .then((quote) => _quoteEventRepository.update(quote));

  Future<Quote> get(String quoteId) => _quotesRepository.find(quoteId);

  Future<void> delete(String quoteId) => _quotesRepository.delete(quoteId);

  Future<void> deleteByAuthor(String authorId) => _quotesRepository
      .deleteByAuthor(authorId)
      .then((_) => _quoteEventRepository.deleteByAuthor(authorId));
}
