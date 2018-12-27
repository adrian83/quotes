import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';

import '../domain/author/service.dart';
import '../domain/author/model.dart';
import '../domain/book/service.dart';
import '../domain/book/model.dart';
import '../domain/quote/service.dart';
import '../domain/quote/model.dart';

import 'common/breadcrumb.dart';
import 'common/error_handler.dart';
import 'common/pagination.dart';
import 'common/events.dart';
import 'common/navigable.dart';

import '../domain/common/page.dart';

@Component(
  selector: 'search',
  templateUrl: 'search.template.html',
  providers: [
    ClassProvider(AuthorService),
    ClassProvider(BookService),
    ClassProvider(QuoteService)
  ],
  directives: const [
    coreDirectives,
    formDirectives,
    Events,
    Breadcrumbs,
    Pagination
  ],
)
class SearchComponent extends ErrorHandler with Navigable {
  final AuthorService _authorService;
  final BookService _bookService;
  final QuoteService _quoteService;

  final Router _router;

  AuthorPageSwitcher _authorPageSwitcher;
  BookPageSwitcher _bookPageSwitcher;
  QuotePageSwitcher _quotePageSwitcher;

  String phrase = "";

  SearchComponent(this._authorService, this._bookService, this._quoteService,
      this._router) {
    _authorPageSwitcher = AuthorPageSwitcher(_authorService, this);
    _authorPageSwitcher.change(0);
    _bookPageSwitcher = BookPageSwitcher(_bookService, this);
    _bookPageSwitcher.change(0);
    _quotePageSwitcher = QuotePageSwitcher(_quoteService, this);
    _quotePageSwitcher.change(0);
  }

  PageSwitcher get authorSwitcher => _authorPageSwitcher;
  AuthorsPage get authorPage => _authorPageSwitcher.page;

  PageSwitcher get bookSwitcher => _bookPageSwitcher;
  BooksPage get bookPage => _bookPageSwitcher.page;

  PageSwitcher get quoteSwitcher => _quotePageSwitcher;
  QuotesPage get quotePage => _quotePageSwitcher.page;

  void executeSearch() {
    _authorPageSwitcher.search(phrase);
    _bookPageSwitcher.search(phrase);
    _quotePageSwitcher.search(phrase);
  }

  void showAuthor(Author author) => _router.navigate(showAuthorUrl(author.id));

  void editAuthor(Author author) => _router.navigate(editAuthorUrl(author.id));

  void showBook(Book book) =>
      _router.navigate(showBookUrl(book.authorId, book.id));

  void editBook(Book book) =>
      _router.navigate(editBookUrl(book.authorId, book.id));

  void showQuote(Quote quote) =>
      _router.navigate(showQuoteUrl(quote.authorId, quote.bookId, quote.id));

  void editQuote(Quote quote) =>
      _router.navigate(editQuoteUrl(quote.authorId, quote.bookId, quote.id));
}

abstract class SearchResult<T extends Page> extends PageSwitcher {
  ErrorHandler _parent;
  String _phrase;
  T _page;

  SearchResult(this._parent);

  T get page => _page;

  void _fetchPage(int pageNumber);

  void search(String phrase) {
    _phrase = phrase;
    change(0);
  }

  @override
  void change(int pageNumber) => _fetchPage(pageNumber);
}

class AuthorPageSwitcher extends SearchResult<AuthorsPage> {
  AuthorService _authorService;

  AuthorPageSwitcher(this._authorService, ErrorHandler parent) : super(parent);

  void _fetchPage(int pageNumber) => _authorService
      .list(PageRequest.page(pageNumber), _phrase)
      .then((newPage) => _page = newPage)
      .catchError(_parent.handleError);
}

class BookPageSwitcher extends SearchResult<BooksPage> {
  BookService _bookService;

  BookPageSwitcher(this._bookService, ErrorHandler parent) : super(parent);

  void _fetchPage(int pageNumber) => _bookService
      .find(_phrase, PageRequest.page(pageNumber))
      .then((newPage) => _page = newPage)
      .catchError(_parent.handleError);
}

class QuotePageSwitcher extends SearchResult<QuotesPage> {
  QuoteService _quoteService;

  QuotePageSwitcher(this._quoteService, ErrorHandler parent) : super(parent);

  void _fetchPage(int pageNumber) => _quoteService
      .find(_phrase, PageRequest.page(pageNumber))
      .then((newPage) => _page = newPage)
      .catchError(_parent.handleError);
}
