import 'dart:io';

import 'form.dart';

import '../common.dart';
import '../common/form.dart';

import '../../domain/quote/service.dart';
import '../../domain/quote/model.dart';

class UpdateQuoteHandler extends Handler {
  static final _URL = r"/authors/{authorId}/books/{bookId}/quotes/{quoteId}";

  QuotesService _quotesService;

  UpdateQuoteHandler(this._quotesService) : super(_URL, "PUT") {}

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

    parseForm(request, QuoteFormParser(true, true))
        .then((form) =>
            Quote(quoteId.value, form.text, authorId.value, bookId.value, form.modifiedUtc, form.createdUtc))
        .then((quote) => _quotesService.update(quote))
        .then((quote) => ok(quote, request))
        .catchError((e) => handleErrors(e, request));
  }
}
