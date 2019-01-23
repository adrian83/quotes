import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:logging/logging.dart';

import '../../domain/common/event.dart';
import '../../domain/common/page.dart';
import '../../domain/common/router.dart';
import '../../domain/author/model.dart';
import '../../domain/author/service.dart';
import '../common/error_handler.dart';
import '../common/events.dart';
import '../common/pagination.dart';

@Component(
  selector: 'author-search',
  templateUrl: 'author_search.template.html',
  providers: [
    ClassProvider(AuthorService),
    ClassProvider(QuotesRouter),
    ClassProvider(ErrorHandler)
  ],
  directives: const [coreDirectives, formDirectives, Events, Pagination],
)
class AuthorSearchComponent implements PageSwitcher {
  static final Logger logger = Logger('AuthorSearchComponent');

  final AuthorService _authorService;
  final ErrorHandler _errorHandler;
  final QuotesRouter _router;

  AuthorsPage _authorsPage = AuthorsPage.empty();

  AuthorSearchComponent(this._authorService, this._errorHandler, this._router);

  String _phrase;

  @Input()
  void set phrase(String p) {
    _phrase = p;

    _authorService
        .listAuthors(_phrase, PageRequest.page(_authorsPage.info.curent))
        .then((page) => _authorsPage = page)
        .catchError(_errorHandler.handleError);
  }

  AuthorsPage get page => _authorsPage;
  PageSwitcher get switcher => this;
  List<Event> get events => _errorHandler.events;

  @override
  void change(int pageNumber) => _authorService
      .listAuthors(_phrase, PageRequest.page(pageNumber))
      .then((page) => _authorsPage = page)
      .catchError(_errorHandler.handleError);

  void showAuthor(Author author) => _router.showAuthor(author.id);

  void editAuthor(Author author) => _router.editAuthor(author.id);
}
