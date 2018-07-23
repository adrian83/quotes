import '../repository/quotes.dart';
import '../domain/quote.dart';

class QuotesService {
  QuotesRepository repo;

  QuotesService(this.repo);

  List<Quote> findQuotes() {
    return repo.list();
  }

  Quote save(Quote quote){
	return repo.save(quote);
  }
}
