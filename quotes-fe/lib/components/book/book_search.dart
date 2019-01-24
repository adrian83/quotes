import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:logging/logging.dart';

import '../../domain/common/event.dart';
import '../../domain/common/page.dart';
import '../../domain/common/router.dart';
import '../../domain/book/model.dart';
import '../../domain/book/service.dart';
import '../common/error_handler.dart';
import '../common/events.dart';
import '../common/pagination.dart';

@Component(
  selector: 'book-search',
  templateUrl: 'book_search.template.html',
  providers: [
    ClassProvider(BookService),
    ClassProvider(QuotesRouter),
    ClassProvider(ErrorHandler)
  ],
  directives: const [coreDirectives, formDirectives, Events, Pagination],
)
class BookSearchComponent implements PageSwitcher {
  static final Logger logger = Logger('BookSearchComponent');

  final BookService _bookService;
  final ErrorHandler _errorHandler;
  final QuotesRouter _router;

  BooksPage _booksPage = BooksPage.empty();

  BookSearchComponent(this._bookService, this._errorHandler, this._router);

  String _phrase;

  @Input()
  void set phrase(String p) {
    _phrase = p;
    change(_booksPage.info.curent);
    logger.info("searching for books with phrase $_phrase");
  }

  BooksPage get page => _booksPage;
  PageSwitcher get switcher => this;
  List<Event> get events => _errorHandler.events;

  @override
  void change(int pageNumber) => _bookService
      .listBooks(_phrase, PageRequest.page(pageNumber))
      .then((page) => _booksPage = page)
      .catchError(_errorHandler.handleError);

  void showBook(Book book) => _router.showBook(book.authorId, book.id);

  void editBook(Book book) => _router.editBook(book.authorId, book.id);
}
