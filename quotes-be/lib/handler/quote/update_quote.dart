import 'dart:io';

import '../../domain/quote/model.dart';
import '../../domain/quote/service.dart';
import '../../common/tuple.dart';
import '../common.dart';
import '../common/form.dart';
import '../response.dart';
import '../form.dart';
import '../error_handler.dart';
import 'params.dart';
import 'form.dart';

class UpdateQuoteHandler extends Handler {
  QuoteService _quoteService;

  UpdateQuoteHandler(this._quoteService) : super();

  void execute(HttpRequest req, PathParams pathParams, UrlParams urlParams) =>
      parseForm(req, QuoteFormParser(true, true))
          .then((form) => Tuple2(
              form,
              QuoteIdParams(
                  pathParams.getString("authorId"), pathParams.getString("bookId"), pathParams.getString("quoteId"))))
          .then((tuple2) => Tuple2(tuple2.e1, tuple2.e2.validate()))
          .then((tuple2) => createQuote(tuple2.e2, tuple2.e1))
          .then((quote) => _quoteService.update(quote))
          .then((quote) => ok(quote, req))
          .catchError((e) => handleErrors(e, req));

  Quote createQuote(QuoteIdValidParams params, QuoteForm form) =>
      Quote(params.quoteId, form.text, params.authorId, params.bookId, nowUtc(), form.createdUtc);
}
