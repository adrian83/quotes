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

  void execute(
      HttpRequest request, PathParseResult pathParams, UrlParams urlParams) {
    var authorId = pathParams.getString("authorId");
    var bookId = pathParams.getString("bookId");
    var quoteId = pathParams.getString("quoteId");
    var errors = ParseElem.errors([authorId, bookId, quoteId]);
    if (errors.length > 0) {
      badRequest(errors, request);
      return;
    }

    parseForm(request, QuoteFormParser())
        .then((form) =>
            Quote(quoteId.value, form.text, authorId.value, bookId.value))
        .then((quote) => _quotesService.update(quote))
        .then((quote) => ok(quote, request))
        .catchError((e) => handleErrors(e, request));
  }
}
