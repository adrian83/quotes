import 'dart:io';

import './../common.dart';
import '../../domain/common/form.dart';
import '../../domain/quote/service.dart';
import '../../domain/quote/form.dart';
import '../../domain/quote/model.dart';

class AddQuoteHandler extends Handler {
  static final _URL = r"/authors/{authorId}/books/{bookId}/quotes";

  QuotesService _quotesService;

  AddQuoteHandler(this._quotesService) : super(_URL, "POST");

  void execute(HttpRequest request) async {
    var pathParsed = parsePath(request.requestedUri.pathSegments);
    var authorIdOrErr = pathParsed.getString("authorId");
    var bookIdOrErr = pathParsed.getString("bookId");

    var errors = ParseElem.errors([authorIdOrErr, bookIdOrErr]);
    if (errors.length > 0) {
      badRequest(errors, request);
      return;
    }

    var result = await parseForm(request, new QuoteFormParser());
    if (result.hasErrors()) {
      badRequest(result.errors, request);
      return;
    }

    var quote = formToQuote(result.form, authorIdOrErr.value, bookIdOrErr.value);
    var saved = _quotesService.save(quote);
    created(saved, request);
  }

  Quote formToQuote(QuoteForm form, String authorId, String bookId) {
    return new Quote(null, form.text, authorId, bookId);
  }
}
