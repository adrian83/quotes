import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:logging/logging.dart';

import '../common/error_handler.dart';
import '../common/pagination.dart';
import '../common/events.dart';

import '../../domain/quote/service.dart';
import '../../domain/quote/model.dart';
import '../../routes.dart';

@Component(
  selector: 'show-quote',
  templateUrl: 'show_quote.template.html',
  providers: [ClassProvider(QuoteService)],
  directives: const [
    coreDirectives,
    Events,
    Pagination
  ],
)
class ShowQuoteComponent extends ErrorHandler with OnActivate {
  static final Logger logger = new Logger('ShowQuoteComponent');

  static final int pageSize = 2;

  final QuoteService _quoteService;

  Quote _quote = Quote(null, "", null, null);

  ShowQuoteComponent(this._quoteService);

  Quote get quote => _quote;

  @override
  void onActivate(_, RouterState current) {
    var authorId = current.parameters[authorIdParam];
    var bookId = current.parameters[bookIdParam];
    var quoteId = current.parameters[quoteIdParam];
    logger.info("Show quote with id: $quoteId");
    _quoteService
        .get(authorId, bookId, quoteId)
        .then((quote) => _quote = quote)
        .catchError(handleError);
  }
}
