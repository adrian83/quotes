import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:logging/logging.dart';

import '../../routes.dart';
import '../../domain/book/service.dart';
import '../../domain/book/model.dart';
import '../../domain/quote/service.dart';
import '../../domain/quote/model.dart';

import '../common/error_handler.dart';
import '../../domain/common/page.dart';
import '../common/pagination.dart';
import '../common/error.dart';
import '../common/info.dart';
import '../common/validation.dart';

@Component(
  selector: 'show-book',
  templateUrl: 'show_book.template.html',
  providers: [ClassProvider(BookService), ClassProvider(QuoteService)],
  directives: const [
    coreDirectives,
    Pagination,
    ValidationErrorsComponent,
    ServerErrorsComponent,
    InfoComponent
  ],
)
class ShowBookComponent extends PageSwitcher with ErrorHandler, OnActivate {
  static final Logger logger = Logger('ShowBookComponent');

  static final int pageSize = 2;

  final BookService _bookService;
  final QuoteService _quoteService;
  final Router _router;

  Book _book = Book(null, "", null);
  QuotesPage _quotesPage = QuotesPage.empty();

  ShowBookComponent(this._bookService, this._quoteService, this._router);

  Book get book => _book;
  QuotesPage get quotesPage => _quotesPage;
  PageSwitcher get quotesSwitcher => this;

  @override
  void onActivate(_, RouterState current) {
    var authorId = current.parameters[authorIdParam];
    var bookId = current.parameters[bookIdParam];
    logger.info("Show book with id: $bookId");

    _bookService
        .get(authorId, bookId)
        .then((book) => _book = book)
        .catchError(handleError);

    _quoteService
        .list(authorId, bookId,
            new PageRequest(pageSize, _quotesPage.info.curent * pageSize))
        .then((page) => _quotesPage = page)
        .catchError(handleError);
  }

  @override
  void change(int pageNumber) {
    _quoteService
        .list(_book.authorId, _book.id,
            new PageRequest(pageSize, pageNumber * pageSize))
        .then((page) => _quotesPage = page)
        .catchError(handleError);
  }

  void deleteQuote(Quote quote) {
    logger.info("Deleting quote: $quote");

    _quoteService
        .delete(quote.authorId, quote.bookId, quote.id)
        .then((id) {
          var quote = _quotesPage.elements.firstWhere((q) => q.id == id);
          showInfo("Quote '${quote.text}' removed");
          return id;
        })
        .then((id) => _quotesPage.elements.removeWhere((q) => q.id == id))
        .then((_) => _quotesPage.info.total -= 1)
        .then((_) => PageRequest(pageSize, (_quotesPage.info.curent + 1) * pageSize))
        .then((req) => _quoteService.list(_book.authorId, _book.id, req))
        .then((nextPage) => nextPage.empty
            ? null
            : _quotesPage.elements.add(nextPage.elements[0]))
        .then((_) => _quotesPage.empty ? change(0) : null)
        .catchError(handleError);
  }

  String _quoteDetailsUrl(String authorId, String bookId, String quoteId) => RoutePaths.showQuote
      .toUrl(parameters: {authorIdParam: authorId, bookIdParam: bookId, quoteIdParam: quoteId});

  void quoteDetails(Quote quote) =>
      _router.navigate(_quoteDetailsUrl(quote.authorId, quote.bookId, quote.id));

  String _quoteEtitionUrl(String authorId, String bookId, String quoteId) => RoutePaths.editQuote
      .toUrl(parameters: {authorIdParam: authorId, bookIdParam: bookId, quoteIdParam: quoteId});

  void editQuote(Quote quote) =>
      _router.navigate(_quoteEtitionUrl(quote.authorId, quote.bookId, quote.id));

}
