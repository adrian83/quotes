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
    var authorId = pathParsed.getString("authorId");
    var bookId = pathParsed.getString("bookId");

    var errors = ParseElem.errors([authorId, bookId]);
    if (errors.length > 0) {
      badRequest(errors, request);
      return;
    }

    var result = await parseForm(request, new QuoteFormParser());
    if (result.hasErrors()) {
      badRequest(result.errors, request);
      return;
    }

    var quote = formToQuote(result.form, authorId.value, bookId.value);
    
    _quotesService
        .save(quote)
        .then((q) => created(q, request))
        .catchError((e) => handleErrors(e, request));
  }

  Quote formToQuote(QuoteForm form, String authorId, String bookId) =>
      Quote(null, form.text, authorId, bookId);
}
