import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';
import 'package:logging/logging.dart';

import '../../domain/book/event.dart';
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
  selector: 'book-events',
  templateUrl: 'book_events.template.html',
  providers: [ClassProvider(BookService), ClassProvider(QuotesRouter), ClassProvider(ErrorHandler)],
  directives: [coreDirectives, formDirectives, Events, Breadcrumbs, Pagination],
)
class BookEventsComponent extends PageSwitcher implements OnActivate {
  static final Logger logger = Logger('BookEventsComponent');

  static final int pageSize = 10;

  final BookService _bookService;
  final ErrorHandler _errorHandler;
  final QuotesRouter _router;

  BookEventsPage _bookEventPage = BookEventsPage.empty();
  String _authorId;
  String _bookId;

  BookEventsComponent(this._bookService, this._errorHandler, this._router);

  PageSwitcher get switcher => this;
  BookEventsPage get page => _bookEventPage;
  List<Event> get events => _errorHandler.events;

  @override
  void onActivate(_, RouterState state) {
    _authorId = _router.param(authorIdParam, state);
    _bookId = _router.param(bookIdParam, state);
    _fetchFirstPage();
    logger.info("activated for book with id: $_bookId");
  }

  @override
  void change(int pageNumber) => _fetchPage(pageNumber);

  void _fetchFirstPage() => _fetchPage(0);

  void _fetchPage(int pageNumber) => Future.value(PageRequest.pageWithSize(pageNumber, pageSize))
      .then((req) => _bookService.listEvents(_authorId, _bookId, req))
      .then((page) => _bookEventPage = page)
      .catchError(_errorHandler.handleError);

  void showBook() => _router.showBook(_bookEventPage.elements.last.authorId, _bookEventPage.elements.last.id);

  List<Breadcrumb> get breadcrumbs {
    var elems = [Breadcrumb.link(_router.search(), "search")];

    if (page.elements.length > 0) {
      var url = _router.showBookUrl(_authorId, _bookId);
      elems.add(Breadcrumb.link(url, page.elements.last.title).last());
    }
    return elems;
  }
}
