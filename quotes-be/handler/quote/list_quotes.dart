import 'dart:io';

import './../common.dart';

import '../../domain/quote/service.dart';
import '../../domain/common/form.dart';
import '../../domain/common/model.dart';

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

    var params = new UrlParams(request.requestedUri.queryParameters);

    var limit = params.getIntOrElse("limit", 2);
    if (limit.hasError()) {
      badRequest([limit.error], request);
      return;
    }

    var offset = params.getIntOrElse("offset", 0);
    if (offset.hasError()) {
      badRequest([offset.error], request);
      return;
    }

    var req = new PageRequest(limit.value, offset.value);

    _quotesService
        .findQuotes(bookIdOrErr.value, req)
        .then((p) => ok(p, request))
        .catchError((e) => handleErrors(e, request));
  }
}
