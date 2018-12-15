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

import '../../domain/author/service.dart';
import '../../domain/author/model.dart';
import '../../domain/common/page.dart';
import '../../routes.dart';

@Component(
  selector: 'author-events',
  templateUrl: 'author_events.template.html',
  providers: [ClassProvider(AuthorService)],
  directives: const [
    coreDirectives,
    formDirectives,
    Events,
    Breadcrumbs,
    Pagination
  ],
)
class AuthorEventsComponent extends PageSwitcher
    with ErrorHandler, Navigable
    implements OnActivate {
  static final Logger logger = Logger('AuthorEventsComponent');

  static final int pageSize = 10;

  final AuthorService _authorService;
    final Router _router;

  AuthorEventsPage _authorEventPage = AuthorEventsPage.empty();
  String _authorId;

  AuthorEventsComponent(this._authorService, this._router);

  PageSwitcher get switcher => this;
  AuthorEventsPage get page => _authorEventPage;

  @override
  void onActivate(_, RouterState state) {
    _authorId = param(authorIdParam, state);
    _fetchFirstPage();
  }

  @override
  void change(int pageNumber) => _fetchPage(pageNumber);

  void _fetchFirstPage() => _fetchPage(0);

  void _fetchPage(int pageNumber) =>
      Future.value(PageRequest.pageWithSize(pageNumber, pageSize))
          .then((req) => _authorService.listEvents(_authorId, req))
          .then((page) => _authorEventPage = page)
          .catchError(handleError);

  void showAuthor() => _router.navigate(showAuthorUrl(_authorEventPage.elements.last.id));

  List<Breadcrumb> get breadcrumbs {
    var elems = [Breadcrumb.link(listAuthorsUrl(), "authors")];

    if (_authorId == null || page.elements.length == 0) return elems;
    elems.add(Breadcrumb.link(showAuthorUrl(_authorId), page.elements.last.name).last());

    return elems;
  }

}
