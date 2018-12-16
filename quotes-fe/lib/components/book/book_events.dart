import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:logging/logging.dart';

import '../common/breadcrumb.dart';
import '../common/error_handler.dart';
import '../common/pagination.dart';
import '../common/events.dart';
import '../common/navigable.dart';

import '../../domain/book/service.dart';
import '../../domain/book/event.dart';
import '../../domain/common/page.dart';
import '../../routes.dart';

@Component(
  selector: 'book-events',
  templateUrl: 'book_events.template.html',
  providers: [ClassProvider(BookService)],
  directives: const [
    coreDirectives,
    formDirectives,
    Events,
    Breadcrumbs,
    Pagination
  ],
)
class BookEventsComponent extends PageSwitcher
    with ErrorHandler, Navigable
    implements OnActivate {
  static final Logger logger = Logger('BookEventsComponent');

  static final int pageSize = 10;

  final BookService _bookService;
    final Router _router;

  BookEventsPage _bookEventPage = BookEventsPage.empty();
  String _authorId;
  String _bookId;

  BookEventsComponent(this._bookService, this._router);

  PageSwitcher get switcher => this;
  BookEventsPage get page => _bookEventPage;

  @override
  void onActivate(_, RouterState state) {
    _authorId = param(authorIdParam, state);
    _bookId = param(bookIdParam, state);
    _fetchFirstPage();
  }

  @override
  void change(int pageNumber) => _fetchPage(pageNumber);

  void _fetchFirstPage() => _fetchPage(0);

  void _fetchPage(int pageNumber) =>
      Future.value(PageRequest.pageWithSize(pageNumber, pageSize))
          .then((req) => _bookService.listEvents(_authorId, _bookId, req))
          .then((page) => _bookEventPage = page)
          .catchError(handleError);

  void showBook() => _router.navigate(showBookUrl(_bookEventPage.elements.last.authorId, _bookEventPage.elements.last.id));

  List<Breadcrumb> get breadcrumbs {
    var elems = [Breadcrumb.link(listAuthorsUrl(), "authors")];

    if (_authorId == null || page.elements.length == 0) return elems;
    elems.add(Breadcrumb.link(showAuthorUrl(_authorId), "tmp name").last());

    return elems;
  }

}
