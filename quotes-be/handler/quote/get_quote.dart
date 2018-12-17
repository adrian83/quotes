import 'dart:io';

import '../common.dart';
import '../common/form.dart';

import '../../domain/quote/service.dart';

class GetQuoteHandler extends Handler {
  static final _URL = r"/authors/{authorId}/books/{bookId}/quotes/{quoteId}";

  QuoteService _quoteService;

  GetQuoteHandler(this._quoteService) : super(_URL, "GET");

  void execute(
      HttpRequest request, PathParams pathParams, UrlParams urlParams) {
    var authorId = pathParams.getString("authorId");
    var bookId = pathParams.getString("bookId");
    var quoteId = pathParams.getString("quoteId");

    var errors = ParseElem.errors([authorId, bookId, quoteId]);
    if (errors.length > 0) {
      badRequest(errors, request);
      return;
    }

    _quoteService
        .get(quoteId.value)
        .then((q) => ok(q, request))
        .catchError((e) => handleErrors(e, request));
  }
}
