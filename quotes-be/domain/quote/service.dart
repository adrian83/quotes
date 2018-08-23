import 'repository.dart';
import 'model.dart';

class QuotesService {
  QuotesRepository _quotesRepository;

  QuotesService(this._quotesRepository);

  List<Quote> findQuotes(String authorId, String bookId) => _quotesRepository.findQuotes(authorId, bookId);
  Quote save(Quote quote) => _quotesRepository.save(quote);
  Quote update(Quote quote) => _quotesRepository.update(quote);
  Quote find(String authorId, String bookId, String quoteId) => _quotesRepository.find(authorId, bookId, quoteId);

  void delete(String authorId, String bookId, String quoteId) {
    _quotesRepository.delete(authorId, bookId, quoteId);
  }

}
