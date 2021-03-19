import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:logging/logging.dart';

import '../../domain/author/model.dart';
import '../../domain/common/event.dart';
import '../../domain/common/page.dart';
import '../../domain/common/router.dart';
import '../../domain/book/model.dart';
import '../../domain/book/service.dart';
import '../common/error_handler.dart';
import '../common/events.dart';
import '../common/pagination.dart';

@Component(
  selector: 'author-books',
  templateUrl: 'author_books.template.html',
  providers: [ClassProvider(BookService), ClassProvider(QuotesRouter), ClassProvider(ErrorHandler)],
  directives: [coreDirectives, formDirectives, Events, Pagination],
)
class AuthorBooksComponent implements PageSwitcher {
  static final Logger logger = Logger('AuthorBooksComponent');

  final BookService _bookService;
  final ErrorHandler _errorHandler;
  final QuotesRouter _router;

  BooksPage _booksPage = BooksPage.empty();

  AuthorBooksComponent(this._bookService, this._errorHandler, this._router);

  Author _author;

  @Input()
  void set author(Author a) {
    _author = a;
    change(_booksPage.info.curent);
    logger.info("searching for books written by author with id: ${_author.id}");
  }

  BooksPage get page => _booksPage;
  PageSwitcher get switcher => this;
  List<Event> get events => _errorHandler.events;
  Author get author => _author;

  @override
  void change(int pageNumber) => _bookService
      .listAuthorBooks(_author.id, PageRequest.page(pageNumber))
      .then((page) => _booksPage = page)
      .catchError(_errorHandler.handleError);

  void deleteBook(Book book) => _bookService
      .delete(_author.id, book.id)
      .then((id) => _errorHandler.showInfo("Book '${book.title}' removed"))
      .then((_) => _booksPage.elements.remove(book))
      .then((_) => _booksPage.empty ? 0 : _booksPage.info.curent)
      .then((pageNumber) => change(pageNumber))
      .catchError(_errorHandler.handleError);

  void showBook(Book book) => _router.showBook(_author.id, book.id);

  void editBook(Book book) => _router.editBook(_author.id, book.id);
}
