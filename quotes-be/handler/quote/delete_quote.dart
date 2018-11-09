import 'dart:io';

import '../common.dart';
import '../common/form.dart';

import '../../domain/quote/service.dart';

class DeleteQuoteHandler extends Handler {
  static final _URL = r"/authors/{authorId}/books/{bookId}/quotes/{quoteId}";

  QuotesService _quotesService;

  DeleteQuoteHandler(this._quotesService) : super(_URL, "DELETE");

  void execute(HttpRequest request, PathParams pathParams, UrlParams urlParams) {
    var authorId = pathParams.getString("authorId");
    var bookId = pathParams.getString("bookId");
    var quoteId = pathParams.getString("quoteId");

    var errors = ParseElem.errors([authorId, bookId, quoteId]);
    if (errors.length > 0) {
      badRequest(errors, request);
      return;
    }

    _quotesService
        .delete(quoteId.value)
        .then((_) => ok(null, request))
        .catchError((e) => handleErrors(e, request));
  }
}
