import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:logging/logging.dart';

import '../../domain/common/event.dart';
import '../../domain/common/page.dart';
import '../../domain/common/router.dart';
import '../../domain/quote/model.dart';
import '../../domain/quote/service.dart';
import '../common/error_handler.dart';
import '../common/events.dart';
import '../common/pagination.dart';

@Component(
  selector: 'quote-search',
  templateUrl: 'quote_search.template.html',
  providers: [
    ClassProvider(QuoteService),
    ClassProvider(QuotesRouter),
    ClassProvider(ErrorHandler)
  ],
  directives: const [coreDirectives, formDirectives, Events, Pagination],
)
class QuoteSearchComponent implements PageSwitcher {
  static final Logger logger = Logger('QuoteSearchComponent');

  final QuoteService _quoteService;
  final ErrorHandler _errorHandler;
  final QuotesRouter _router;

  QuotesPage _quotesPage = QuotesPage.empty();

  QuoteSearchComponent(this._quoteService, this._errorHandler, this._router);

  String _phrase;

  @Input()
  void set phrase(String p) {
    _phrase = p;
    change(0);
    logger.info("searching for quotes with phrase $_phrase");
  }

  QuotesPage get page => _quotesPage;
  PageSwitcher get switcher => this;
  List<Event> get events => _errorHandler.events;

  @override
  void change(int pageNumber) => _quoteService
      .listQuotes(_phrase, PageRequest.page(pageNumber))
      .then((page) => _quotesPage = page)
      .catchError(_errorHandler.handleError);

  void showQuote(Quote quote) =>
      _router.showQuote(quote.authorId, quote.bookId, quote.id);

  void editQuote(Quote quote) =>
      _router.editQuote(quote.authorId, quote.bookId, quote.id);
}
