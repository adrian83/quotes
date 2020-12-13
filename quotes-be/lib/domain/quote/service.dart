import 'dart:async';

import '../common/model.dart';
import 'event.dart';
import 'model.dart';
import 'repository.dart';

class QuoteService {
  QuoteRepository _quotesRepository;
  QuoteEventRepository _quoteEventRepository;

  QuoteService(this._quotesRepository, this._quoteEventRepository);

  Future<Quote> save(Quote quote) => _quotesRepository.save(quote).then((quote) => _quoteEventRepository.save(quote));

  Future<Quote> find(String quoteId) => _quotesRepository.find(quoteId);

  Future<Quote> update(Quote quote) => _quotesRepository.update(quote).then((quote) => _quoteEventRepository.update(quote));

  Future<void> delete(String quoteId) => _quotesRepository.delete(quoteId).then((_) => _quoteEventRepository.delete(quoteId));

  Future<Page<Quote>> findBookQuotes(ListQuotesFromBookRequest request) => _quotesRepository.findBookQuotes(request);

  Future<Page<Quote>> findQuotes(SearchEntityRequest request) => _quotesRepository.findQuotes(request);

  Future<Page<QuoteEvent>> listEvents(ListEventsByQuoteRequest request) => _quoteEventRepository.listEvents(request);

  Future<void> deleteByAuthor(String authorId) => _quotesRepository.deleteByAuthor(authorId).then((_) => _quoteEventRepository.deleteByAuthor(authorId));
}
