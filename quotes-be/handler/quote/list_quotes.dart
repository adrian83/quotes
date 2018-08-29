import 'dart:io';

import './../common.dart';
import '../../domain/quote/service.dart';
import '../../domain/common/form.dart';

class ListQuotesHandler extends Handler {
  static final _URL = r"/authors/{authorId}/books/{bookId}/quotes";

  QuotesService _quotesService;

  ListQuotesHandler(this._quotesService) : super(_URL, "GET") {}

  void execute(HttpRequest request) {
    var pathParsed = parsePath(request.requestedUri.pathSegments);
    var authorIdOrErr = pathParsed.getString("authorId");
    var bookIdOrErr = pathParsed.getString("bookId");

    var errors = ParseElem.errors([authorIdOrErr, bookIdOrErr]);
    if (errors.length > 0) {
      badRequest(errors, request);
      return;
    }

    var quotes = _quotesService.findQuotes(authorIdOrErr.value, bookIdOrErr.value);
    ok(quotes, request);
  }
}
