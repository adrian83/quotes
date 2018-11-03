import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:logging/logging.dart';

import '../common/breadcrumb.dart';
import '../common/navigable.dart';
import '../common/error_handler.dart';
import '../common/pagination.dart';
import '../common/events.dart';

import '../../domain/author/service.dart';
import '../../domain/author/model.dart';
import '../../domain/book/service.dart';
import '../../domain/book/model.dart';
import '../../domain/quote/service.dart';
import '../../domain/quote/model.dart';
import '../../domain/common/page.dart';
import '../../routes.dart';

@Component(
  selector: 'show-book',
  templateUrl: 'show_book.template.html',
  providers: [
    ClassProvider(AuthorService),
    ClassProvider(BookService),
    ClassProvider(QuoteService)
  ],
  directives: const [coreDirectives, Breadcrumbs, Events, Pagination],
)
class ShowBookComponent extends PageSwitcher
    with ErrorHandler, Navigable, OnActivate {
  static final Logger logger = Logger('ShowBookComponent');

  final AuthorService _authorService;
  final BookService _bookService;
  final QuoteService _quoteService;
  final Router _router;

  Author _author = Author.empty();
  Book _book = Book.empty();
  QuotesPage _quotesPage = QuotesPage.empty();

  ShowBookComponent(
      this._authorService, this._bookService, this._quoteService, this._router);

  Book get book => _book;
  QuotesPage get quotesPage => _quotesPage;
  PageSwitcher get quotesSwitcher => this;

  @override
  void onActivate(_, RouterState current) {
    var authorId = current.parameters[authorIdParam];
    var bookId = current.parameters[bookIdParam];
    logger.info("Activating...");

    _authorService
        .get(authorId)
        .then((author) => _author = author)
        .catchError(handleError);

    _bookService
        .get(authorId, bookId)
        .then((book) => _book = book)
        .catchError(handleError);

    _quoteService
        .list(authorId, bookId, PageRequest.page(_quotesPage.info.curent))
        .then((page) => _quotesPage = page)
        .catchError(handleError);
  }

  @override
  void change(int pageNumber) => _quoteService
      .list(_book.authorId, _book.id, PageRequest.page(pageNumber))
      .then((page) => _quotesPage = page)
      .catchError(handleError);

  void deleteQuote(Quote quote) {
    logger.info("Deleting quote: $quote");

    _quoteService
        .delete(quote.authorId, quote.bookId, quote.id)
        .then((id) => showInfo("Quote '${quote.text}' removed"))
        .then((_) => _quotesPage.elements.remove(quote))
        .then((_) => _quotesPage.info.total -= 1)
        .then((_) => PageRequest.page(_quotesPage.info.curent + 1))
        .then((req) => _quoteService.list(_book.authorId, _book.id, req))
        .then((nextPage) => nextPage.empty
            ? null
            : _quotesPage.elements.add(nextPage.elements[0]))
        .then((_) => _quotesPage.empty ? change(0) : null)
        .catchError(handleError);
  }

  void deleteBook() => _bookService
      .delete(_book.authorId, _book.id)
      .then((_) => showInfo("Book '${_book.title}' deleted"))
      .then((_) => _book = Book.empty())
      .catchError(handleError);

  void showAuthor() => _router.navigate(showAuthorUrl(_book.authorId));

  void showQuote(Quote quote) =>
      _router.navigate(showQuoteUrl(quote.authorId, quote.bookId, quote.id));

  void editQuote(Quote quote) =>
      _router.navigate(editQuoteUrl(quote.authorId, quote.bookId, quote.id));

  void editBook() => _router.navigate(editBookUrl(_book.authorId, _book.id));

  void createQuote() =>
      _router.navigate(createQuoteUrl(_book.authorId, _book.id));

  List<Breadcrumb> get breadcrumbs => [
        Breadcrumb.link(listAuthorsUrl(), "authors"),
        Breadcrumb.link(showAuthorUrl(_author.id), _author.name),
        Breadcrumb.link(showAuthorUrl(_author.id), "books"),
        Breadcrumb.text(_book.title).last()
      ];
}
