import 'dart:io';

import './../common.dart';
import '../../domain/quote/service.dart';
import '../../domain/quote/form.dart';
import '../../domain/common/form.dart';
import '../../domain/quote/model.dart';

class UpdateQuoteHandler extends Handler {
  static final _URL = r"/authors/{authorId}/books/{bookId}/quotes/{quoteId}";

  QuotesService _quotesService;

  UpdateQuoteHandler(this._quotesService) : super(_URL, "PUT") {}

  void execute(HttpRequest request) {
    var pathParsed = parsePath(request.requestedUri.pathSegments);
    var authorId = pathParsed.getString("authorId");
    var bookId = pathParsed.getString("bookId");
    var quoteId = pathParsed.getString("quoteId");
    var errors = ParseElem.errors([authorId, bookId, quoteId]);
    if (errors.length > 0) {
      badRequest(errors, request);
      return;
    }

    parseForm(request, new QuoteFormParser())
        .then((form) =>
            Quote(quoteId.value, form.text, authorId.value, bookId.value))
        .then((quote) async => await _quotesService
            .update(quote)
            .then((q) => ok(q, request))
            .catchError((e) => handleErrors(e, request)))
        .catchError((e) => handleErrors(e, request));
  }

  Quote formToQuote(
      QuoteForm form, String authorId, String bookId, String quoteId) {
    return new Quote(quoteId, form.text, authorId, bookId);
  }
}
