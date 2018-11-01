import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:logging/logging.dart';

import '../common/breadcrumb.dart';
import '../common/error_handler.dart';
import '../common/pagination.dart';
import '../common/events.dart';
import '../common/navigable.dart';

import '../../domain/author/service.dart';
import '../../domain/author/model.dart';
import '../../domain/book/service.dart';
import '../../domain/book/model.dart';
import '../../domain/common/page.dart';
import '../../routes.dart';

@Component(
  selector: 'show-author',
  templateUrl: 'show_author.template.html',
  providers: [ClassProvider(AuthorService), ClassProvider(BookService)],
  directives: const [coreDirectives, Events, Breadcrumbs, Pagination],
)
class ShowAuthorComponent extends PageSwitcher
    with ErrorHandler, Navigable, OnActivate {
  static final Logger logger = new Logger('ShowAuthorComponent');

  static final int pageSize = 2;

  final AuthorService _authorService;
  final BookService _bookService;
  final Router _router;

  Author _author = new Author(null, "");
  BooksPage _booksPage = new BooksPage.empty();

  ShowAuthorComponent(this._authorService, this._bookService, this._router);

  Author get author => _author;
  BooksPage get booksPage => _booksPage;
  PageSwitcher get booksSwitcher => this;

  @override
  void onActivate(_, RouterState current) {
    logger.info("Activating component");

    var authorId = current.parameters[authorIdParam];

    _authorService
        .get(authorId)
        .then((author) => _author = author)
        .then((_) => logger.info("Author fetched: ${_author.name}"))
        .catchError(handleError);

    _bookService
        .list(authorId,
            new PageRequest(pageSize, _booksPage.info.curent * pageSize))
        .then((page) => _booksPage = page)
        .then(
            (_) => logger.info("BooksPage fetched: ${_booksPage.info.curent}"))
        .catchError(handleError);
  }

  @override
  void change(int pageNumber) {
    logger.info("Change page to $pageNumber");
    _bookService
        .list(_author.id, new PageRequest(pageSize, pageNumber * pageSize))
        .then((page) => _booksPage = page)
        .then(
            (_) => logger.info("BooksPage fetched: ${_booksPage.info.curent}"))
        .catchError(handleError);
  }

  void deleteBook(Book book) {
    logger.info("Deleting book: $book");

    _bookService
        .delete(book.authorId, book.id)
        .then((id) => showInfo("Book '${book.title}' removed"))
        .then((id) => _booksPage.elements.remove(book))
        .then((_) => _booksPage.info.total -= 1)
        .then((_) =>
            PageRequest(pageSize, (_booksPage.info.curent + 1) * pageSize))
        .then((req) => _bookService.list(_author.id, req))
        .then((nextPage) => nextPage.empty
            ? null
            : _booksPage.elements.add(nextPage.elements[0]))
        .then((_) => _booksPage.empty ? change(0) : null)
        .catchError(handleError);
  }

  void showBook(Book book) =>
      _router.navigate(showBookUrl(book.authorId, book.id));

  void editBook(Book book) =>
      _router.navigate(editBookUrl(book.authorId, book.id));

  void createBook() => _router.navigate(createBookUrl(_author.id));

  List<Breadcrumb> get breadcrumbs => [
        Breadcrumb.link(RoutePaths.listAuthors.toUrl(), "authors"),
        Breadcrumb.text(_author.name).last()
      ];
}
