import 'dart:async';

import 'model.dart';
import 'repository.dart';

import '../common/model.dart';

class QuotesService {
  QuoteRepository _quotesRepository;

  QuotesService(this._quotesRepository);

  Future<Page<Quote>> findQuotes(String bookId, PageRequest request) =>
      _quotesRepository.find(bookId, request);
  Future<Quote> save(Quote quote) => _quotesRepository.save(quote);
  Future<Quote> update(Quote quote) => _quotesRepository.update(quote);
  Future<Quote> get(String quoteId) => _quotesRepository.get(quoteId);
  Future<void> delete(String quoteId) => _quotesRepository.delete(quoteId);
}
