import 'dart:io';

import '../common.dart';
import '../common/form.dart';

import '../../domain/quote/service.dart';
import '../../domain/common/model.dart';

class ListQuotesHandler extends Handler {
  static final _URL = r"/authors/{authorId}/books/{bookId}/quotes";

  QuoteService _quoteService;

  ListQuotesHandler(this._quoteService) : super(_URL, "GET") {}

  void execute(
      HttpRequest request, PathParams pathParams, UrlParams urlParams) {
    var authorId = pathParams.getString("authorId");
    var bookId = pathParams.getString("bookId");
    var limit = urlParams.getIntOrElse("limit", 2);
    var offset = urlParams.getIntOrElse("offset", 0);

    var errors = ParseElem.errors([authorId, bookId, limit, offset]);
    if (errors.length > 0) {
      badRequest(errors, request);
      return;
    }

    var req = PageRequest(limit.value, offset.value);

    _quoteService
        .findQuotes(bookId.value, req)
        .then((p) => ok(p, request))
        .catchError((e) => handleErrors(e, request));
  }
}
