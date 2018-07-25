import '../domain/quote.dart';

class QuotesRepository {
  List<Quote> quotes = new List<Quote>();
  int nextId = 3;

  QuotesRepository() {
    var q1 = new Quote(1, "Byc albo nie byc");
    var q2 = new Quote(2, "Litwo ojczyzno moja");

    quotes.add(q1);
    quotes.add(q2);
  }

  Quote save(Quote quote) {
    quote.id = nextId;
    nextId++;
    quotes.add(quote);
    return quote;
  }

  List<Quote> list() {
    return quotes;
  }

  Quote update(Quote quote) {
    quotes.removeWhere((e) => e.id == quote.id);
    quotes.add(quote);
    return quote;
  }

  void delete(int quoteId) {
    quotes.removeWhere((e) => e.id == quoteId);
  }

  Quote find(int quoteId) {
    return quotes.firstWhere((e) => e.id == quoteId);
  }
}
