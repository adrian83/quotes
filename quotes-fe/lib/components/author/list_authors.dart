import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:logging/logging.dart';

import '../common/breadcrumb.dart';
import '../common/error.dart';
import '../common/error_handler.dart';
import '../common/info.dart';
import '../common/pagination.dart';
import '../common/validation.dart';

import '../../domain/author/service.dart';
import '../../domain/author/model.dart';
import '../../domain/common/page.dart';
import '../../route_paths.dart';

@Component(
  selector: 'list-authors',
  templateUrl: 'list_authors.template.html',
  providers: [ClassProvider(AuthorService)],
  directives: const [
    coreDirectives,
    formDirectives,
    Breadcrumbs,
    Pagination,
    ValidationErrorsComponent,
    ServerErrorsComponent,
    InfoComponent
  ],
)
class ListAuthorsComponent extends PageSwitcher
    with ErrorHandler
    implements OnInit {
  static final Logger logger = new Logger('ListAuthorsComponent');

  static final int pageSize = 2;

  final AuthorService _authorService;
  final Router _router;

  AuthorsPage _authorsPage = new AuthorsPage.empty();

  ListAuthorsComponent(this._authorService, this._router);

  @override
  void ngOnInit() => _fetchFirstPage();

  @override
  void change(int pageNumber) => _fetchPage(pageNumber);

  PageSwitcher get switcher => this;
  AuthorsPage get page => _authorsPage;

  void _fetchFirstPage() => _fetchPage(0);

  void _fetchPage(int pageNumber) {
    logger.info("Fething authors page with index: $pageNumber");
    _authorService
        .list(new PageRequest(pageSize, pageNumber * pageSize))
        .then((page) => _authorsPage = page)
        .catchError(handleError);
  }

  void deleteAuthor(Author author) {
    logger.info("Deleting author: $author");
    _authorService
        .delete(author.id)
        .then((id) => showInfo("Author '${author.name}' removed"))
        .then((_) => _authorsPage.elements.remove(author))
        .then((_) => _authorsPage.info.total -= 1)
        .then((_) =>
            PageRequest(pageSize, (_authorsPage.info.curent + 1) * pageSize))
        .then((req) => _authorService.list(req))
        .then((nextPage) => nextPage.empty
            ? null
            : _authorsPage.elements.add(nextPage.elements[0]))
        .then((_) => _authorsPage.empty ? _fetchPage(0) : null)
        .catchError(handleError);
  }

  String _showAuthorUrl(String id) =>
      RoutePaths.showAuthor.toUrl(parameters: {authorIdParam: id});

  String _editAuthorUrl(String id) =>
      RoutePaths.editAuthor.toUrl(parameters: {authorIdParam: id});

  String _createAuthorUrl() => RoutePaths.newAuthor.toUrl();

  void showAuthor(Author author) => _router.navigate(_showAuthorUrl(author.id));

  void editAuthor(Author author) => _router.navigate(_editAuthorUrl(author.id));

  void createAuthor() => _router.navigate(_createAuthorUrl());

  List<Breadcrumb> get breadcrumbs =>
      [Breadcrumb(_createAuthorUrl(), "authors", false, true)];
}
