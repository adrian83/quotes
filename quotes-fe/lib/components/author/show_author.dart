import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import 'package:logging/logging.dart';

import '../../routes.dart';
import '../../domain/author/service.dart';
import '../../domain/author/model.dart';
import '../../domain/book/service.dart';
import '../../domain/book/model.dart';

import '../common/error_handler.dart';
import '../../domain/common/page.dart';
import '../common/pagination.dart';
import '../common/error.dart';
import '../common/info.dart';
import '../common/validation.dart';

@Component(
  selector: 'show-author',
  templateUrl: 'show_author.template.html',
  providers: [ClassProvider(AuthorService), ClassProvider(BookService)],
  directives: const [
    coreDirectives,
    Pagination,
    ValidationErrorsComponent,
    ServerErrorsComponent,
    InfoComponent
  ],
)
class ShowAuthorComponent extends PageSwitcher with ErrorHandler, OnActivate {
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
  Future<void> onActivate(_, RouterState current) async {
    var id = current.parameters[authorIdParam];
    logger.info("Show author with id: $id");
    _author = await _authorService.get(id).catchError(handleError);

    _booksPage = await _bookService
        .list(id, new PageRequest(pageSize, _booksPage.info.curent * pageSize))
        .catchError(handleError);
  }

  @override
  void change(int pageNumber) async {
    _booksPage = await _bookService
        .list(_author.id, new PageRequest(pageSize, pageNumber * pageSize))
        .catchError(handleError);
  }

  String _bookDetailsUrl(String authorId, String bookId) => RoutePaths
      .showBook
      .toUrl(parameters: {authorIdParam: '$authorId', bookIdParam: '$bookId'});

  void bookDetails(Book book) =>
      _router.navigate(_bookDetailsUrl(book.authorId, book.id));
}
