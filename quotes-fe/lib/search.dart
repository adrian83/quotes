import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:logging/logging.dart';

import 'domain/author/service.dart';
import 'domain/author/model.dart';
import 'domain/book/service.dart';
import 'domain/book/model.dart';
import 'domain/quote/service.dart';
import 'domain/quote/model.dart';

import 'components/common/breadcrumb.dart';
import 'components/common/error_handler.dart';
import 'components/common/pagination.dart';
import 'components/common/events.dart';
import 'components/common/navigable.dart';

import 'domain/common/page.dart';

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
class SearchComponent extends ErrorHandler {
  final AuthorService _authorService;
  final BookService _bookService;
  final QuoteService _quoteService;

  AuthorPageSwitcher _authorPageSwitcher;
  BookPageSwitcher _bookPageSwitcher;

  String phrase = "";

  SearchComponent(this._authorService, this._bookService, this._quoteService) {
    _authorPageSwitcher = AuthorPageSwitcher(_authorService, this);
    _authorPageSwitcher.change(0);
    _bookPageSwitcher = BookPageSwitcher(_bookService, this);
    _bookPageSwitcher.change(0);
  }

  PageSwitcher get authorSwitcher => _authorPageSwitcher;
  AuthorsPage get authorPage => _authorPageSwitcher.page;

  PageSwitcher get bookSwitcher => _bookPageSwitcher;
  BooksPage get bookPage => _bookPageSwitcher.page;

  List<Breadcrumb> get breadcrumbs => [Breadcrumb.text("authors").last()];

  void search() {
    _authorPageSwitcher.search(phrase);
    _bookPageSwitcher.search(phrase);
  }
}

class AuthorPageSwitcher extends PageSwitcher {
  AuthorService _authorService;
  ErrorHandler _parent;

  String _phrase;

  AuthorsPage _authorsPage = AuthorsPage.empty();

  AuthorPageSwitcher(this._authorService, this._parent);

  AuthorsPage get page => _authorsPage;

  void search(String phrase) {
    _phrase = phrase;
    change(0);
  }

  @override
  void change(int pageNumber) => _fetchPage(pageNumber);

  void _fetchPage(int pageNumber) => _authorService
      .list(PageRequest.page(pageNumber), _phrase)
      .then((page) => _authorsPage = page)
      .catchError(_parent.handleError);
}

class BookPageSwitcher extends PageSwitcher {
  BookService _bookService;
  ErrorHandler _parent;

  String _phrase;

  BooksPage _booksPage = BooksPage.empty();

  BookPageSwitcher(this._bookService, this._parent);

  BooksPage get page => _booksPage;

  void search(String phrase) {
    _phrase = phrase;
    change(0);
  }

  @override
  void change(int pageNumber) => _fetchPage(pageNumber);

  void _fetchPage(int pageNumber) => _bookService
      .find(_phrase, PageRequest.page(pageNumber))
      .then((page) => _booksPage = page)
      .catchError(_parent.handleError);
}
