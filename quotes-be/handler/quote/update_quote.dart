import 'dart:io';

import '../../domain/quote/model.dart';
import '../../domain/quote/service.dart';
import '../../tools/tuple.dart';
import '../common.dart';
import '../common/form.dart';
import '../common/params.dart';
import 'form.dart';

class UpdateQuoteHandler extends Handler {
  static final _URL = r"/authors/{authorId}/books/{bookId}/quotes/{quoteId}";

  QuoteService _quoteService;

  UpdateQuoteHandler(this._quoteService) : super(_URL, "PUT") {}

  void execute(HttpRequest req, PathParams pathParams, UrlParams urlParams) {
    var params = Params()
      ..authorIdParam = pathParams.getString("authorId")
      ..bookIdParam = pathParams.getString("bookId")
      ..quoteIdParam = pathParams.getString("quoteId");

    parseForm(req, QuoteFormParser(true, true))
        .then((form) => Tuple2(form, params))
        .then((tuple2) => Tuple2(tuple2.e1, tuple2.e2.validate()))
        .then((tuple2) => createQuote(tuple2.e2, tuple2.e1))
        .then((quote) => _quoteService.update(quote))
        .then((quote) => ok(quote, req))
        .catchError((e) => handleErrors(e, req));
  }

  Quote createQuote(Params params, QuoteForm form) => Quote(params.quoteId,
      form.text, params.authorId, params.bookId, nowUtc(), form.createdUtc);
}
