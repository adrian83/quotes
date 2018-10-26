import 'dart:io';

import './../common.dart';
import '../../domain/quote/service.dart';
import '../../domain/common/form.dart';

class GetQuoteHandler extends Handler {
  static final _URL = r"/authors/{authorId}/books/{bookId}/quotes/{quoteId}";

  QuotesService _quotesService;

  GetQuoteHandler(this._quotesService) : super(_URL, "GET");

  void execute(HttpRequest request) async {
    var pathParsed = parsePath(request.requestedUri.pathSegments);
    var authorIdOrErr = pathParsed.getString("authorId");
    var bookIdOrErr = pathParsed.getString("bookId");
    var quoteIdOrErr = pathParsed.getString("quoteId");

    var errors = ParseElem.errors([authorIdOrErr, bookIdOrErr, quoteIdOrErr]);
    if (errors.length > 0) {
      badRequest(errors, request);
      return;
    }

    _quotesService
        .get(quoteIdOrErr.value)
        .then((q) => ok(q, request))
        .catchError((e) => handleErrors(e, request));
  }
}
