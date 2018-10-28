import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular_forms/angular_forms.dart';

import '../../domain/quote/service.dart';
import '../../domain/quote/model.dart';
import '../../route_paths.dart';

import '../common/error_handler.dart';

import '../common/error.dart';
import '../common/info.dart';
import '../common/validation.dart';

@Component(
  selector: 'new-quote',
  templateUrl: 'new_quote.template.html',
  providers: [ClassProvider(QuoteService)],
  directives: const [
    coreDirectives,
    formDirectives,
    ValidationErrorsComponent,
    ServerErrorsComponent,
    InfoComponent
  ],
)
class NewQuoteComponent extends ErrorHandler implements OnActivate {
  final QuoteService _quoteService;
  final Router _router;

  Quote _quote = new Quote(null, "", null, null);

  NewQuoteComponent(this._quoteService, this._router);

  @override
  void onActivate(_, RouterState current) {
    _quote.authorId = current.parameters[authorIdParam];
    _quote.bookId = current.parameters[bookIdParam];
  }

  Quote get quote => _quote;

  void save() {
    _quoteService
        .create(quote)
        .then((quote) => _quote = quote)
        .then((_) => _edit(_quote))
        .catchError(handleError);
  }

  String _editionUrl(String authorId, String bookId, String quoteId) => RoutePaths.editQuote
      .toUrl(parameters: {authorIdParam: authorId, bookIdParam: bookId, quoteIdParam: quoteId});

  void _edit(Quote quote) =>
      _router.navigate(_editionUrl(quote.authorId, quote.bookId, quote.id));
}