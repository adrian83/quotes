import 'package:uuid/uuid.dart';
import '../domain/quote.dart';

class QuotesRepository {
  List<Quote> quotes = new List<Quote>();

  QuotesRepository() {
    var q1 = new Quote(new Uuid().v4(), "Byc albo nie byc", "pl");
    var q2 = new Quote(new Uuid().v4(), "Litwo ojczyzno moja", "pl");

    quotes.add(q1);
    quotes.add(q2);
  }

  Quote save(Quote quote) {
    quote.id = new Uuid().v4();
    quotes.add(quote);
    return quote;
  }

  List<Quote> list() => quotes;
  Quote find(String quoteId) => quotes.firstWhere((e) => e.id == quoteId);

  Quote update(Quote quote) {
    quotes.removeWhere((e) => e.id == quote.id);
    quotes.add(quote);
    return quote;
  }

  void delete(String quoteId) {
    quotes.removeWhere((e) => e.id == quoteId);
  }

}
