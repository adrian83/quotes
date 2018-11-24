import 'dart:async';

import 'package:uuid/uuid.dart';

import 'model.dart';
import 'repository.dart';

import '../common/model.dart';

class QuotesService {
  QuoteRepository _quotesRepository;

  QuotesService(this._quotesRepository);

  Future<Page<Quote>> findQuotes(String bookId, PageRequest request) =>
      _quotesRepository.findQuotes(bookId, request);

  Future<Quote> save(Quote quote) {
    quote.id = Uuid().v4();
    return _quotesRepository.save(quote);
    //.then((_) => _authorEventRepository.save(author));
  }
  // => _quotesRepository.save(quote);

  Future<Quote> update(Quote quote) => _quotesRepository.update(quote);
  Future<Quote> get(String quoteId) => _quotesRepository.find(quoteId);
  Future<void> delete(String quoteId) => _quotesRepository.delete(quoteId);
}
