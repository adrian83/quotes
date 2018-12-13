import 'dart:async';

import 'model.dart';
import 'repository.dart';
import 'event.dart';

import '../common/model.dart';

class QuotesService {
  QuoteRepository _quotesRepository;
  QuoteEventRepository _quoteEventRepository;

  QuotesService(this._quotesRepository, this._quoteEventRepository);

  Future<Page<Quote>> findQuotes(String bookId, PageRequest request) =>
      _quotesRepository.findQuotes(bookId, request);

  Future<Quote> save(Quote quote) => _quotesRepository
      .save(quote.generateId())
      .then((quote) => _quoteEventRepository.save(quote));

  Future<Quote> update(Quote quote) => _quotesRepository.update(quote);
  Future<Quote> get(String quoteId) => _quotesRepository.find(quoteId);
  Future<void> delete(String quoteId) => _quotesRepository.delete(quoteId);

  Future<void> deleteByAuthor(String authorId) =>
      _quotesRepository.deleteByAuthor(authorId)
      .then((_) => _quoteEventRepository.deleteByAuthor(authorId));
}
