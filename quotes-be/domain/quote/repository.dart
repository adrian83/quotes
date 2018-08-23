import 'package:uuid/uuid.dart';
import 'model.dart';

class QuotesRepository {
  List<Quote> quotes = new List<Quote>();

  Quote save(Quote quote) {
    quote.id = new Uuid().v4();
    quotes.add(quote);
    return quote;
  }

  List<Quote> findQuotes(String authorId, String bookId) => quotes.where((q) => q.authorId == authorId && q.bookId == bookId).toList();
  Quote find(String authorId, String bookId, String quoteId) => quotes.firstWhere((e) => findByIds(e, authorId, bookId, quoteId));

  Quote update(Quote quote) {
    quotes.removeWhere((e) => e.id == quote.id);
    quotes.add(quote);
    return quote;
  }

  void delete(String authorId, String bookId, String quoteId) {
    quotes.removeWhere((e) => findByIds(e, authorId, bookId, quoteId));
  }

  bool findByIds(Quote quote, String authorId, String bookId, String quoteId) {
      return quote.authorId == authorId && quote.bookId == bookId && quote.id == quoteId;
  }

}
