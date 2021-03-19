import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:logging/logging.dart';

import 'package:quotes_fe/domain/common/event.dart';
import 'package:quotes_fe/domain/common/page.dart';
import 'package:quotes_fe/domain/common/router.dart';
import 'package:quotes_fe/domain/author/model.dart';
import 'package:quotes_fe/domain/author/service.dart';
import 'package:quotes_fe/components/common/error_handler.dart';
import 'package:quotes_fe/components/common/events.dart';
import 'package:quotes_fe/components/common/pagination.dart';

@Component(
  selector: 'author-search',
  templateUrl: 'author_search.template.html',
  providers: [ClassProvider(AuthorService), ClassProvider(QuotesRouter), ClassProvider(ErrorHandler)],
  directives: [coreDirectives, formDirectives, Events, Pagination],
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
  void set phrase(String phrase) {
    _phrase = phrase;
    change(0);
    logger.info("searching for authors with phrase $_phrase");
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
