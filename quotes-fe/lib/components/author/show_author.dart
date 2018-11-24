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
  static final Logger logger = Logger('ShowAuthorComponent');

  final AuthorService _authorService;
  final BookService _bookService;
  final Router _router;

  Author _author = Author.empty();
  BooksPage _booksPage = BooksPage.empty();

  ShowAuthorComponent(this._authorService, this._bookService, this._router);

  Author get author => _author;
  BooksPage get booksPage => _booksPage;
  PageSwitcher get booksSwitcher => this;

  @override
  void onActivate(_, RouterState state) => _authorService
      .get(param(authorIdParam, state))
      .then((author) => _author = author)
      .then((_) => PageRequest.page(_booksPage.info.curent))
      .then((listReq) => _bookService.list(_author.id, listReq))
      .then((page) => _booksPage = page)
      .catchError(handleError);

  @override
  void change(int pageNumber) => _bookService
      .list(_author.id, PageRequest.page(pageNumber))
      .then((page) => _booksPage = page)
      .catchError(handleError);

  void deleteBook(Book book) => _bookService
      .delete(book.authorId, book.id)
      .then((id) => showInfo("Book '${book.title}' removed"))
      .then((id) => _booksPage.elements.remove(book))
      .then((_) => _booksPage.empty ? 0 : _booksPage.info.curent)
      .then((pageNumber) => change(pageNumber))
      .catchError(handleError);

  void deleteAuthor() => _authorService
      .delete(_author.id)
      .then((_) => showInfo("Author '${_author.name}' deleted"))
      .then((_) => _author = Author.empty())
      .catchError(handleError);

  void editAuthor() => _router.navigate(editAuthorUrl(_author.id));

  void showBook(Book book) =>
      _router.navigate(showBookUrl(book.authorId, book.id));

  void editBook(Book book) =>
      _router.navigate(editBookUrl(book.authorId, book.id));

  void createBook() => _router.navigate(createBookUrl(_author.id));

  List<Breadcrumb> get breadcrumbs {
    var elems = [Breadcrumb.link(RoutePaths.listAuthors.toUrl(), "authors")];

    if (_author.id == null) return elems;
    elems.add(Breadcrumb.text(_author.name).last());

    return elems;
  }
}
