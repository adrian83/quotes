import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:logging/logging.dart';

import '../../domain/author/model.dart';
import '../../domain/author/service.dart';
import '../../domain/book/model.dart';
import '../../domain/book/service.dart';
import '../../domain/common/event.dart';
import '../../domain/common/router.dart';
import '../../routes.dart';
import '../common/breadcrumb.dart';
import '../common/error_handler.dart';
import '../common/events.dart';
import '../common/pagination.dart';
import '../quote/book_quotes.dart';

@Component(
  selector: 'show-book',
  templateUrl: 'show_book.template.html',
  providers: [
    ClassProvider(AuthorService),
    ClassProvider(BookService),
    ClassProvider(QuotesRouter),
    ClassProvider(ErrorHandler)
  ],
  directives: const [
    coreDirectives,
    Breadcrumbs,
    Events,
    Pagination,
    BookQuotesComponent
  ],
)
class ShowBookComponent extends OnActivate {
  static final Logger logger = Logger('ShowBookComponent');

  final AuthorService _authorService;
  final BookService _bookService;
  final ErrorHandler _errorHandler;
  final QuotesRouter _router;

  Author _author = Author.empty();
  Book _book = Book.empty();

  ShowBookComponent(
      this._authorService, this._bookService, this._errorHandler, this._router);

  Book get book => _book;
  List<Event> get events => _errorHandler.events;

  @override
  void onActivate(_, RouterState state) => _authorService
      .get(_router.param(authorIdParam, state))
      .then((author) => _author = author)
      .then((_) => _router.param(bookIdParam, state))
      .then((bookId) => _bookService.get(_author.id, bookId))
      .then((book) => _book = book)
      .catchError(_errorHandler.handleError);

  void deleteBook() => _bookService
      .delete(_book.authorId, _book.id)
      .then((_) => _errorHandler.showInfo("Book '${_book.title}' deleted"))
      .then((_) => _book = Book.empty())
      .catchError(_errorHandler.handleError);

  void showAuthor() => _router.showAuthor(_book.authorId);

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
