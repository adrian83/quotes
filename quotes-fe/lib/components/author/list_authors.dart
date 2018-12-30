import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:logging/logging.dart';

import '../../domain/author/model.dart';
import '../../domain/author/service.dart';
import '../../domain/common/event.dart';
import '../../domain/common/page.dart';
import '../../domain/common/router.dart';
import '../common/breadcrumb.dart';
import '../common/error_handler.dart';
import '../common/events.dart';
import '../common/pagination.dart';

@Component(
  selector: 'list-authors',
  templateUrl: 'list_authors.template.html',
  providers: [
    ClassProvider(AuthorService),
    ClassProvider(QuotesRouter),
    ClassProvider(ErrorHandler)
  ],
  directives: const [
    coreDirectives,
    formDirectives,
    Events,
    Breadcrumbs,
    Pagination
  ],
)
class ListAuthorsComponent extends PageSwitcher implements OnInit {
  static final Logger logger = Logger('ListAuthorsComponent');

  final AuthorService _authorService;
  final ErrorHandler _errorHandler;
  final QuotesRouter _router;

  AuthorsPage _authorsPage = AuthorsPage.empty();

  ListAuthorsComponent(this._authorService, this._errorHandler, this._router);

  PageSwitcher get switcher => this;
  AuthorsPage get page => _authorsPage;
  List<Event> get events => _errorHandler.events;

  @override
  void ngOnInit() => _fetchFirstPage();

  @override
  void change(int pageNumber) => _fetchPage(pageNumber);

  void _fetchFirstPage() => _fetchPage(0);

  void _fetchPage(int pageNumber) => _authorService
      .list(PageRequest.page(pageNumber))
      .then((page) => _authorsPage = page)
      .catchError(_errorHandler.handleError);

  void deleteAuthor(Author author) => _authorService
      .delete(author.id)
      .then((id) => _errorHandler.showInfo("Author '${author.name}' removed"))
      .then((_) => _authorsPage.elements.remove(author))
      .then((_) => _authorsPage.empty ? 0 : _authorsPage.info.curent)
      .then((pageNumber) => _fetchPage(pageNumber))
      .catchError(_errorHandler.handleError);

  void showAuthor(Author author) => _router.showAuthor(author.id);

  void editAuthor(Author author) => _router.editAuthor(author.id);

  void createAuthor() => _router.createAuthor();

  List<Breadcrumb> get breadcrumbs =>
      [Breadcrumb.link(_router.search(), "search").last()];
}
