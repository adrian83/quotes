import 'dart:io';

import '../../domain/quote/model.dart';
import '../../domain/quote/service.dart';
import '../common.dart';
import '../common/form.dart';
import 'form.dart';

class AddQuoteHandler extends Handler {
  static final _URL = r"/authors/{authorId}/books/{bookId}/quotes";

  QuoteService _quoteService;

  AddQuoteHandler(this._quoteService) : super(_URL, "POST");

  void execute(
      HttpRequest request, PathParams pathParams, UrlParams urlParams) {
    var authorId = pathParams.getString("authorId");
    var bookId = pathParams.getString("bookId");

    var errors = ParseElem.errors([authorId, bookId]);
    if (errors.length > 0) {
      badRequest(errors, request);
      return;
    }

    parseForm(request, QuoteFormParser(false, false))
        .then((form) => fromForm(form, authorId.value, bookId.value))
        .then((quote) => _quoteService.save(quote))
        .then((quote) => created(quote, request))
        .catchError((e) => handleErrors(e, request));
  }

  Quote fromForm(QuoteForm form, String authorId, String bookId) =>
      Quote(null, form.text, authorId, bookId, nowUtc(), nowUtc());
}
