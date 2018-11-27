import 'dart:io';

import 'form.dart';

import '../common.dart';
import '../common/form.dart';

import '../../domain/quote/service.dart';
import '../../domain/quote/model.dart';

class AddQuoteHandler extends Handler {
  static final _URL = r"/authors/{authorId}/books/{bookId}/quotes";

  QuotesService _quotesService;

  AddQuoteHandler(this._quotesService) : super(_URL, "POST");

  void execute(HttpRequest request, PathParams pathParams, UrlParams urlParams) {
    var authorId = pathParams.getString("authorId");
    var bookId = pathParams.getString("bookId");

    var errors = ParseElem.errors([authorId, bookId]);
    if (errors.length > 0) {
      badRequest(errors, request);
      return;
    }

    parseForm(request, QuoteFormParser(false, false))
        .then((form) => Quote(null, form.text, authorId.value, bookId.value, nowUtc(), nowUtc()))
        .then((quote) => _quotesService.save(quote))
        .then((quote) => created(quote, request))
        .catchError((e) => handleErrors(e, request));
  }
}
