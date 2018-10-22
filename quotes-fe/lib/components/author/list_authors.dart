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
  static final Logger LOGGER = new Logger('ListAuthorsComponent');

  static final int pageSize = 3;
  int _page = 0;

  final AuthorService _authorService;
  final Router _router;

  AuthorsPage authorsPage = new AuthorsPage.empty();

  ListAuthorsComponent(this._authorService, this._router);

  @override
  void ngOnInit() => _getAuthors();

  Future<void> _getAuthors() async => fetchPage(_page);

  PageSwitcher get switcher => this;

  @override
  void change(int pageNumber) async {
    _page = pageNumber;
    fetchPage(_page);
  }

  void fetchPage(int pageNumber) async {
    _page = pageNumber;
    _authorService
        .list(new PageRequest(pageSize, _page * pageSize))
        .then((p) => this.authorsPage = p, onError: handleError)
        .whenComplete(() {
      if (_page != 0 && authorsPage.empty) fetchPage(0);
    });
  }

  void details(Author author) => _router.navigate(_detailsUrl(author.id));

  void edit(Author author) => _router.navigate(_editionUrl(author.id));

  void delete(Author author) async {
    var nextPage = await _authorService.list(new PageRequest(pageSize, (_page+1) * pageSize));
    await _authorService
        .delete(author.id)
        .then((id) => authorsPage.elements.removeWhere((a) => a.id == id))
        .then((_) => showInfo("Author removed"))
        .then((_) {
          if(!nextPage.empty) {
            authorsPage.elements.add(nextPage.elements[0]);
          }
          authorsPage.info.total -= 1;
          if(authorsPage.empty) {
            fetchPage(0);
          }
        })
        .catchError(handleError);
  }

  String _detailsUrl(String id) =>
      RoutePaths.showAuthor.toUrl(parameters: {authorIdParam: '$id'});

  String _editionUrl(String id) =>
      RoutePaths.editAuthor.toUrl(parameters: {authorIdParam: '$id'});
}
