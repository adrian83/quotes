import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:logging/logging.dart';

import '../../domain/book/model.dart';
import '../../domain/common/event.dart';
import '../../domain/common/page.dart';
import '../../domain/common/router.dart';
import '../../domain/quote/model.dart';
import '../../domain/quote/service.dart';
import '../common/error_handler.dart';
import '../common/events.dart';
import '../common/pagination.dart';

@Component(
  selector: 'book-quotes',
  templateUrl: 'book_quotes.template.html',
  providers: [
    ClassProvider(QuoteService),
    ClassProvider(QuotesRouter),
    ClassProvider(ErrorHandler)
  ],
  directives: const [coreDirectives, formDirectives, Events, Pagination],
)
class BookQuotesComponent implements PageSwitcher {
  static final Logger logger = Logger('BookQuotesComponent');

  final QuoteService _quoteService;
  final ErrorHandler _errorHandler;
  final QuotesRouter _router;

  QuotesPage _quotesPage = QuotesPage.empty();

  BookQuotesComponent(this._quoteService, this._errorHandler, this._router);

  Book _book;

  @Input()
  void set book(Book b) {
    _book = b;

    _quoteService
        .listBookQuotes(
            _book.authorId, _book.id, PageRequest.page(_quotesPage.info.curent))
        .then((page) => _quotesPage = page)
        .catchError(_errorHandler.handleError);
  }

  QuotesPage get page => _quotesPage;
  PageSwitcher get switcher => this;
  List<Event> get events => _errorHandler.events;
  Book get book => _book;

  @override
  void change(int pageNumber) => _quoteService
      .listBookQuotes(_book.authorId, _book.id, PageRequest.page(pageNumber))
      .then((page) => _quotesPage = page)
      .catchError(_errorHandler.handleError);

  void deleteQuote(Quote quote) => _quoteService
      .delete(quote.authorId, quote.bookId, quote.id)
      .then((id) => _errorHandler.showInfo("Quote '${quote.text}' removed"))
      .then((_) => _quotesPage.elements.remove(quote))
      .then((_) => _quotesPage.empty ? 0 : _quotesPage.info.curent)
      .then((pageNumber) => change(pageNumber))
      .catchError(_errorHandler.handleError);

  void showQuote(Quote quote) =>
      _router.showQuote(quote.authorId, quote.bookId, quote.id);

  void editQuote(Quote quote) =>
      _router.editQuote(quote.authorId, quote.bookId, quote.id);
}
