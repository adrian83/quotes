import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular_forms/angular_forms.dart';

import 'package:logging/logging.dart';

import '../../route_paths.dart';
import '../../domain/author/service.dart';
import '../../domain/author/model.dart';
import '../../domain/common/page.dart';

import '../common/error_handler.dart';

import '../common/pagination.dart';
import '../common/error.dart';
import '../common/info.dart';
import '../common/validation.dart';

@Component(
  selector: 'list-authors',
  templateUrl: 'list_authors.template.html',
  providers: [ClassProvider(AuthorService)],
  directives: const [
    coreDirectives,
    formDirectives,
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

  static final int pageSize = 3;

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

  Future<void> _fetchFirstPage() => _fetchPage(0);

  Future<void> _fetchPage(int pageNumber) async {
    logger.info("Fething authors page with index: $pageNumber");
    _authorsPage = await _authorService
        .list(new PageRequest(pageSize, pageNumber * pageSize))
        .catchError(handleError);
  }

  Future<void> delete(Author author) async {
    logger.info("Deleting author: $author");
    var nextPage = await _authorService.list(
        new PageRequest(pageSize, (_authorsPage.info.curent + 1) * pageSize));

    return _authorService
        .delete(author.id)
        .then((id) {
          var author = _authorsPage.elements.firstWhere((a) => a.id == id);
          showInfo("Author '${author.name}' removed");
          return id;
        })
        .then((id) => _authorsPage.elements.removeWhere((a) => a.id == id))
        .then((_) => _authorsPage.info.total -= 1)
        .then((_) => nextPage.empty
            ? null
            : _authorsPage.elements.add(nextPage.elements[0]))
        .then((_) => _authorsPage.empty ? _fetchPage(0) : null)
        .catchError(handleError);
  }

  String _detailsUrl(String id) =>
      RoutePaths.showAuthor.toUrl(parameters: {authorIdParam: '$id'});

  String _editionUrl(String id) =>
      RoutePaths.editAuthor.toUrl(parameters: {authorIdParam: '$id'});

  void details(Author author) => _router.navigate(_detailsUrl(author.id));

  void edit(Author author) => _router.navigate(_editionUrl(author.id));
}
