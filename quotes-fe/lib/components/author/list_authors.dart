import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular_forms/angular_forms.dart';

import 'package:logging/logging.dart';

import '../../route_paths.dart';
import '../../domain/author/service.dart';
import '../../domain/author/model.dart';
import '../../domain/common/page.dart';

import '../common/pagination.dart';

@Component(
  selector: 'list-authors',
  templateUrl: 'list_authors.template.html',
  providers: [ClassProvider(AuthorService)],
  directives: const [coreDirectives, formDirectives, Pagination],
)
class ListAuthorsComponent extends PageSwitcher implements OnInit {
static final Logger LOGGER = new Logger('ListAuthorsComponent');

  static final int pageSize = 3;

  final AuthorService _authorService;
  final Router _router;

  AuthorsPage authorsPage = new AuthorsPage.empty();
  String errorMessage;

  ListAuthorsComponent(this._authorService, this._router);

  @override
  void ngOnInit() => _getAuthors();

  Future<void> _getAuthors() async {
    fetchPage(0);
  }

  PageSwitcher get switcher => this;

  @override
  void change(int pageNumber) async {
    fetchPage(pageNumber);
  }

  void fetchPage(int pageNumber) async {
    try {
      var pageReq = new PageRequest(pageSize, 0);
      authorsPage = await _authorService.list(pageReq);
    } catch (e) {
      LOGGER.warning("Error while getting page of authors. Page number: $pageNumber, error: $e");
      errorMessage = e.toString();
    }
  }

  void onSelect(Author author) => _router.navigate(_detailsUrl(author.id));

  void edit(Author author) => _router.navigate(_editionUrl(author.id));

  String _detailsUrl(String id) =>
      RoutePaths.showAuthor.toUrl(parameters: {authorIdParam: '$id'});

  String _editionUrl(String id) =>
      RoutePaths.editAuthor.toUrl(parameters: {authorIdParam: '$id'});
}
