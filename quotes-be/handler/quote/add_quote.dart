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

  void execute(HttpRequest request) {
    var pathParsed = parsePath(request.requestedUri.pathSegments);
    var authorId = pathParsed.getString("authorId");
    var bookId = pathParsed.getString("bookId");

    var errors = ParseElem.errors([authorId, bookId]);
    if (errors.length > 0) {
      badRequest(errors, request);
      return;
    }

    parseForm(request, new QuoteFormParser())
        .then((form) => Quote(null, form.text, authorId.value, bookId.value))
        .then((quote) async => await _quotesService
            .save(quote)
            .then((q) => created(q, request))
            .catchError((e) => handleErrors(e, request)))
        .catchError((e) => handleErrors(e, request));
  }
}
