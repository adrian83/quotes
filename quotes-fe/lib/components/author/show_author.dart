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
import '../../routes.dart';
import '../common/breadcrumb.dart';
import '../common/error_handler.dart';
import '../common/events.dart';
import '../common/pagination.dart';

@Component(
  selector: 'show-author',
  templateUrl: 'show_author.template.html',
  providers: [
    ClassProvider(AuthorService),
    ClassProvider(BookService),
    ClassProvider(QuotesRouter),
    ClassProvider(ErrorHandler)
  ],
  directives: const [coreDirectives, Events, Breadcrumbs, Pagination],
)
class ShowAuthorComponent extends PageSwitcher with OnActivate {
  static final Logger logger = Logger('ShowAuthorComponent');

  final AuthorService _authorService;
  final BookService _bookService;
  final ErrorHandler _errorHandler;
  final QuotesRouter _router;

  Author _author = Author.empty();
  BooksPage _booksPage = BooksPage.empty();

  ShowAuthorComponent(
      this._authorService, this._bookService, this._errorHandler, this._router);

  Author get author => _author;
  BooksPage get booksPage => _booksPage;
  PageSwitcher get booksSwitcher => this;
  List<Event> get events => _errorHandler.events;

  @override
  void onActivate(_, RouterState state) => _authorService
      .get(_router.param(authorIdParam, state))
      .then((author) => _author = author)
      .then((_) => PageRequest.page(_booksPage.info.curent))
      .then((listReq) => _bookService.list(_author.id, listReq))
      .then((page) => _booksPage = page)
      .catchError(_errorHandler.handleError);

  @override
  void change(int pageNumber) => _bookService
      .list(_author.id, PageRequest.page(pageNumber))
      .then((page) => _booksPage = page)
      .catchError(_errorHandler.handleError);

  void deleteBook(Book book) => _bookService
      .delete(book.authorId, book.id)
      .then((_) => _errorHandler.showInfo("Book '${book.title}' deleted"))
      .then((_) => _booksPage.elements.remove(book))
      .then((_) => _booksPage.empty ? 0 : _booksPage.info.curent)
      .then((pageNumber) => change(pageNumber))
      .catchError(_errorHandler.handleError);

  void deleteAuthor() => _authorService
      .delete(_author.id)
      .then((_) => _errorHandler.showInfo("Author '${_author.name}' deleted"))
      .then((_) => _author = Author.empty())
      .catchError(_errorHandler.handleError);

  void editAuthor() => _router.editAuthor(_author.id);

  void showBook(Book book) => _router.showBook(_author.id, book.id);

  void editBook(Book book) => _router.editBook(_author.id, book.id);

  void showEvents() => _router.showAuthorEvents(_author.id);

  void createBook() => _router.createBook(_author.id);

  List<Breadcrumb> get breadcrumbs {
    var elems = [Breadcrumb.link(RoutePaths.search.toUrl(), "search")];

    if (_author.id != null) {
      elems.add(Breadcrumb.text(_author.name).last());
    }
    return elems;
  }
}
