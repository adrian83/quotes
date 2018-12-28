import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';
import 'package:logging/logging.dart';

import '../../domain/common/page.dart';
import '../../domain/common/router.dart';
import '../../domain/quote/event.dart';
import '../../domain/quote/service.dart';
import '../../routes.dart';
import '../common/breadcrumb.dart';
import '../common/error_handler.dart';
import '../common/events.dart';
import '../common/pagination.dart';

import '../../tools/strings.dart';

@Component(
  selector: 'quote-events',
  templateUrl: 'quote_events.template.html',
  providers: [ClassProvider(QuoteService), ClassProvider(QuotesRouter)],
  directives: const [
    coreDirectives,
    formDirectives,
    Events,
    Breadcrumbs,
    Pagination
  ],
)
class QuoteEventsComponent extends PageSwitcher
    with ErrorHandler
    implements OnActivate {
  static final Logger logger = Logger('QuoteEventsComponent');

  static final int pageSize = 10;

  final QuoteService _quoteService;
  final QuotesRouter _router;

  QuoteEventsPage _quoteEventPage = QuoteEventsPage.empty();
  String _authorId;
  String _bookId;
  String _quoteId;

  QuoteEventsComponent(this._quoteService, this._router);

  PageSwitcher get switcher => this;
  QuoteEventsPage get page => _quoteEventPage;

  @override
  void onActivate(_, RouterState state) {
    _authorId = _router.param(authorIdParam, state);
    _bookId = _router.param(bookIdParam, state);
    _quoteId = _router.param(quoteIdParam, state);
    _fetchFirstPage();
  }

  @override
  void change(int pageNumber) => _fetchPage(pageNumber);

  void _fetchFirstPage() => _fetchPage(0);

  void _fetchPage(int pageNumber) =>
      Future.value(PageRequest.pageWithSize(pageNumber, pageSize))
          .then((req) => _quoteService.listEvents(_authorId, _bookId, _quoteId, req))
          .then((page) => _quoteEventPage = page)
          .catchError(handleError);

  void showQuote() => _router.showQuote(_quoteEventPage.elements.last.authorId,
      _quoteEventPage.elements.last.bookId, _quoteEventPage.elements.last.id);

  List<Breadcrumb> get breadcrumbs {
    var elems = [Breadcrumb.link(_router.search(), "search")];

    if (_quoteId != null && page.elements.length > 0) {
      var url = _router.showQuoteUrl(_authorId, _bookId, _quoteId);
      elems.add(Breadcrumb.link(url, shorten(page.elements.last.text, 20)));
    }

    return elems;
  }
}
