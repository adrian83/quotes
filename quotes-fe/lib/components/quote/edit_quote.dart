import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular_forms/angular_forms.dart';

import '../../routes.dart';
import '../../domain/quote/service.dart';
import '../../domain/quote/model.dart';

import '../common/error_handler.dart';

import '../common/error.dart';
import '../common/info.dart';
import '../common/validation.dart';

@Component(
  selector: 'edit-quote',
  templateUrl: 'edit_quote.template.html',
  providers: [ClassProvider(QuoteService)],
  directives: const [
    coreDirectives,
    formDirectives,
    ValidationErrorsComponent,
    ServerErrorsComponent,
    InfoComponent
  ],
)
class EditQuoteComponent extends ErrorHandler implements OnActivate {
  final QuoteService _quoteService;

  Quote _quote = new Quote(null, "", null, null);

  EditQuoteComponent(this._quoteService);

  Quote get quote => _quote;

  @override
  Future<void> onActivate(_, RouterState current) async {
    var authorId = current.parameters[authorIdParam];
    var bookId = current.parameters[bookIdParam];
    var quoteId = current.parameters[quoteIdParam];
    _quoteService
        .get(authorId, bookId, quoteId)
        .then((quote) => _quote = quote)
        .catchError(handleError);
  }

  void update() {
    _quoteService
        .update(_quote)
        .then((quote) => _quote = quote)
        .then((_) => showInfo("Quote '${_quote.text}' updated"))
        .catchError(handleError);
  }
}
