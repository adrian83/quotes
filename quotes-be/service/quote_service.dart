import '../repository/quotes.dart';
import '../domain/quote.dart';

class QuotesService {
  QuotesRepository _quotesRepository;

  QuotesService(this._quotesRepository);

  List<Quote> findQuotes() => _quotesRepository.list();
  Quote save(Quote quote) => _quotesRepository.save(quote);
  Quote update(Quote quote) => _quotesRepository.update(quote);
  Quote find(String quoteId) => _quotesRepository.find(quoteId);

  void delete(String quoteId) {
    _quotesRepository.delete(quoteId);
  }

}
