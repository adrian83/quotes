import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:logging/logging.dart';

import '../../domain/author/model.dart';
import '../../domain/author/service.dart';
import '../../domain/common/event.dart';
import '../../domain/common/router.dart';
import '../../routes.dart';
import '../common/breadcrumb.dart';
import '../common/error_handler.dart';
import '../common/events.dart';
import '../common/pagination.dart';
import '../book/author_books.dart';

@Component(
  selector: 'show-author',
  templateUrl: 'show_author.template.html',
  providers: [ClassProvider(AuthorService), ClassProvider(QuotesRouter), ClassProvider(ErrorHandler)],
  directives: [coreDirectives, Events, Breadcrumbs, Pagination, AuthorBooksComponent],
)
class ShowAuthorComponent extends OnActivate {
  static final Logger logger = Logger('ShowAuthorComponent');

  final AuthorService _authorService;
  final ErrorHandler _errorHandler;
  final QuotesRouter _router;

  Author _author = Author.empty();

  ShowAuthorComponent(this._authorService, this._errorHandler, this._router);

  Author get author => _author;
  List<Event> get events => _errorHandler.events;

  @override
  void onActivate(_, RouterState state) =>
      _authorService.find(_router.param(authorIdParam, state)).then((author) => _author = author).catchError(_errorHandler.handleError);

  void deleteAuthor() => _authorService
      .delete(_author.id)
      .then((_) => _errorHandler.showInfo("Author '${_author.name}' deleted"))
      .then((_) => _author = Author.empty())
      .catchError(_errorHandler.handleError);

  void editAuthor() => _router.editAuthor(_author.id);

  void showEvents() => _router.showAuthorEvents(_author.id);

  void createBook() => _router.createBook(_author.id);

  List<Breadcrumb> get breadcrumbs {
    var elems = [Breadcrumb.link(RoutePaths.search.toUrl(), "search")];

    if (_author.id != null) {
      elems.add(Breadcrumb.text(_author.name).last());
    }
    return elems;
  }
}
