import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';
import 'package:logging/logging.dart';

import 'package:quotes_fe/domain/author/event.dart';
import 'package:quotes_fe/domain/author/service.dart';
import 'package:quotes_fe/domain/common/event.dart';
import 'package:quotes_fe/domain/common/page.dart';
import 'package:quotes_fe/domain/common/router.dart';
import 'package:quotes_fe/routes.dart';
import 'package:quotes_fe/components/common/breadcrumb.dart';
import 'package:quotes_fe/components/common/error_handler.dart';
import 'package:quotes_fe/components/common/events.dart';
import 'package:quotes_fe/components/common/pagination.dart';

@Component(
  selector: 'author-events',
  templateUrl: 'author_events.template.html',
  providers: [ClassProvider(AuthorService), ClassProvider(QuotesRouter), ClassProvider(ErrorHandler)],
  directives: [coreDirectives, formDirectives, Events, Breadcrumbs, Pagination],
)
class AuthorEventsComponent extends PageSwitcher implements OnActivate {
  static final Logger logger = Logger('AuthorEventsComponent');

  static final int pageSize = 10;

  final ErrorHandler _errorHandler;
  final AuthorService _authorService;
  final QuotesRouter _router;

  AuthorEventsPage _authorEventPage = AuthorEventsPage.empty();
  String _authorId;

  AuthorEventsComponent(this._authorService, this._errorHandler, this._router);

  PageSwitcher get switcher => this;
  AuthorEventsPage get page => _authorEventPage;
  List<Event> get events => _errorHandler.events;

  @override
  void onActivate(_, RouterState state) {
    _authorId = _router.param(authorIdParam, state);
    _fetchFirstPage();
    logger.info("activated for author with id:$_authorId");
  }

  @override
  void change(int pageNumber) => _fetchPage(pageNumber);

  void _fetchFirstPage() => _fetchPage(0);

  void _fetchPage(int pageNumber) => Future.value(PageRequest.pageWithSize(pageNumber, pageSize))
      .then((req) => _authorService.listEvents(_authorId, req))
      .then((page) => _authorEventPage = page)
      .catchError(_errorHandler.handleError);

  void showAuthor() => _router.showAuthor(_authorEventPage.elements.last.id);

  List<Breadcrumb> get breadcrumbs {
    var elems = [Breadcrumb.link(_router.search(), "search")];
    if (_authorId != null && page.elements.length > 0) {
      var url = _router.showAuthorUrl(_authorId);
      elems.add(Breadcrumb.link(url, page.elements.last.name).last());
    }
    return elems;
  }
}
