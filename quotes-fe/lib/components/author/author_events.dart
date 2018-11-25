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

  AuthorEventsPage _authorEventPage = AuthorEventsPage.empty();
  String _authorId;

  AuthorEventsComponent(this._authorService);

  PageSwitcher get switcher => this;
  AuthorEventsPage get page => _authorEventPage;

 

  @override
  void onActivate(_, RouterState state){ 
    print("1");
    _authorId = param(authorIdParam, state);
    print(_authorId);
    _fetchFirstPage();
  }

  @override
  void change(int pageNumber) => _fetchPage(pageNumber);

  void _fetchFirstPage() => _fetchPage(0);

  void _fetchPage(int pageNumber) => _authorService
      .listEvents(_authorId, PageRequest.pageWithSize(pageNumber, pageSize))
      .then((page) => _authorEventPage = page)
      .catchError(handleError);

  List<Breadcrumb> get breadcrumbs =>  [Breadcrumb.link(RoutePaths.listAuthors.toUrl(), "authors")];
}
