import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:logging/logging.dart';

import '../../domain/author/model.dart';
import '../../domain/author/service.dart';
import '../../domain/book/model.dart';
import '../../domain/book/service.dart';
import '../../domain/common/event.dart';
import '../../domain/common/page.dart';
import '../../domain/common/router.dart';
import '../../domain/quote/model.dart';
import '../../domain/quote/service.dart';
import '../../routes.dart';
import '../common/breadcrumb.dart';
import '../common/error_handler.dart';
import '../common/events.dart';
import '../common/pagination.dart';

@Component(
  selector: 'show-book',
  templateUrl: 'show_book.template.html',
  providers: [
    ClassProvider(AuthorService),
    ClassProvider(BookService),
    ClassProvider(QuoteService),
    ClassProvider(QuotesRouter),
    ClassProvider(ErrorHandler)
  ],
  directives: const [coreDirectives, Breadcrumbs, Events, Pagination],
)
class ShowBookComponent extends PageSwitcher with OnActivate {
  static final Logger logger = Logger('ShowBookComponent');

  final AuthorService _authorService;
  final BookService _bookService;
  final QuoteService _quoteService;
  final ErrorHandler _errorHandler;
  final QuotesRouter _router;

  Author _author = Author.empty();
  Book _book = Book.empty();
  QuotesPage _quotesPage = QuotesPage.empty();

  ShowBookComponent(this._authorService, this._bookService, this._quoteService,
      this._errorHandler, this._router);

  Book get book => _book;
  QuotesPage get quotesPage => _quotesPage;
  PageSwitcher get quotesSwitcher => this;
  List<Event> get events => _errorHandler.events;

  @override
  void onActivate(_, RouterState state) => _authorService
      .get(_router.param(authorIdParam, state))
      .then((author) => _author = author)
      .then((_) => _router.param(bookIdParam, state))
      .then((bookId) => _bookService.get(_author.id, bookId))
      .then((book) => _book = book)
      .then((_) => PageRequest.page(_quotesPage.info.curent))
      .then((listReq) => _quoteService.list(_author.id, _book.id, listReq))
      .then((page) => _quotesPage = page)
      .catchError(_errorHandler.handleError);

  @override
  void change(int pageNumber) => _quoteService
      .list(_book.authorId, _book.id, PageRequest.page(pageNumber))
      .then((page) => _quotesPage = page)
      .catchError(_errorHandler.handleError);

  void deleteQuote(Quote quote) => _quoteService
      .delete(quote.authorId, quote.bookId, quote.id)
      .then((id) => _errorHandler.showInfo("Quote '${quote.text}' removed"))
      .then((_) => _quotesPage.elements.remove(quote))
      .then((_) => _quotesPage.empty ? 0 : _quotesPage.info.curent)
      .then((pageNumber) => change(pageNumber))
      .catchError(_errorHandler.handleError);

  void deleteBook() => _bookService
      .delete(_book.authorId, _book.id)
      .then((_) => _errorHandler.showInfo("Book '${_book.title}' deleted"))
      .then((_) => _book = Book.empty())
      .catchError(_errorHandler.handleError);

  void showAuthor() => _router.showAuthor(_book.authorId);

  void showQuote(Quote quote) =>
      _router.showQuote(quote.authorId, quote.bookId, quote.id);

  void editQuote(Quote quote) =>
      _router.editQuote(quote.authorId, quote.bookId, quote.id);

  void editBook() => _router.editBook(_book.authorId, _book.id);

  void createQuote() => _router.createQuote(_book.authorId, _book.id);

  void showEvents() => _router.showBookEvents(_author.id, _book.id);

  List<Breadcrumb> get breadcrumbs {
    var elems = [Breadcrumb.link(_router.search(), "search")];

    if (_author.id != null) {
      var url = _router.showAuthorUrl(_author.id);
      elems.add(Breadcrumb.link(url, _author.name));
    }

    if (_book.id != null) {
      elems.add(Breadcrumb.text(_book.title).last());
    }

    return elems;
  }
}
