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

  void execute(HttpRequest request) async {
    var parsedForm = await parseForm(request, new QuoteFormParser());
    if (parsedForm.hasErrors()) {
      badRequest(parsedForm.errors, request);
      return;
    }

    var pathParsed = parsePath(request.requestedUri.pathSegments);
    var authorIdOrErr = pathParsed.getString("authorId");
    var bookIdOrErr = pathParsed.getString("bookId");
    var quoteIdOrErr = pathParsed.getString("quoteId");
    var errors = ParseElem.errors([authorIdOrErr, bookIdOrErr, quoteIdOrErr]);
    if (errors.length > 0) {
      badRequest(errors, request);
      return;
    }

    var quote = formToQuote(parsedForm.form, authorIdOrErr.value, bookIdOrErr.value, quoteIdOrErr.value);
    var saved = _quotesService.update(quote);
    ok(saved, request);
  }

  Quote formToQuote(QuoteForm form, String authorId, String bookId, String quoteId) {
    return new Quote(quoteId, form.text, authorId, bookId);
  }
}
