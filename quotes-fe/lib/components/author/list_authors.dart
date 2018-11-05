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

@Component(
  selector: 'list-authors',
  templateUrl: 'list_authors.template.html',
  providers: [ClassProvider(AuthorService)],
  directives: const [
    coreDirectives,
    formDirectives,
    Events,
    Breadcrumbs,
    Pagination
  ],
)
class ListAuthorsComponent extends PageSwitcher
    with ErrorHandler, Navigable
    implements OnInit {
  static final Logger logger = Logger('ListAuthorsComponent');

  final AuthorService _authorService;
  final Router _router;

  AuthorsPage _authorsPage = AuthorsPage.empty();

  ListAuthorsComponent(this._authorService, this._router);

  PageSwitcher get switcher => this;
  AuthorsPage get page => _authorsPage;

  @override
  void ngOnInit() => _fetchFirstPage();

  @override
  void change(int pageNumber) => _fetchPage(pageNumber);

  void _fetchFirstPage() => _fetchPage(0);

  void _fetchPage(int pageNumber) => _authorService
      .list(PageRequest.page(pageNumber))
      .then((page) => _authorsPage = page)
      .catchError(handleError);

  void deleteAuthor(Author author) => _authorService
      .delete(author.id)
      .then((id) => showInfo("Author '${author.name}' removed"))
      .then((_) => _authorsPage.elements.remove(author))
      .then((_) => _authorsPage.info.total -= 1)
      .then((_) => PageRequest.page(_authorsPage.info.curent + 1))
      .then((req) => _authorService.list(req))
      .then((nextPage) => _authorsPage.last = nextPage.first)
      .then((_) => _authorsPage.empty ? _fetchPage(0) : null)
      .catchError(handleError);

  void showAuthor(Author author) => _router.navigate(showAuthorUrl(author.id));

  void editAuthor(Author author) => _router.navigate(editAuthorUrl(author.id));

  void createAuthor() => _router.navigate(createAuthorUrl());

  List<Breadcrumb> get breadcrumbs => [Breadcrumb.text("authors").last()];
}
