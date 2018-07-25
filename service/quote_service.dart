import '../repository/quotes.dart';
import '../domain/quote.dart';

class QuotesService {
  QuotesRepository repo;

  QuotesService(this.repo);

  List<Quote> findQuotes() {
    return repo.list();
  }

  Quote save(Quote quote) {
    return repo.save(quote);
  }

  Quote update(Quote quote) {
    return repo.update(quote);
  }

  void delete(int quoteId) {
    repo.delete(quoteId);
  }

  Quote find(int quoteId) {
    return repo.find(quoteId);
  }
}
