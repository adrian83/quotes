import 'dart:io';

import '../../domain/quote/model.dart';
import '../../domain/quote/service.dart';
import '../../tools/tuple.dart';
import '../common.dart';
import '../common/form.dart';
import '../common/params.dart';
import 'form.dart';

class AddQuoteHandler extends Handler {
  static final _URL = r"/authors/{authorId}/books/{bookId}/quotes";

  QuoteService _quoteService;

  AddQuoteHandler(this._quoteService) : super(_URL, "POST");

  void execute(HttpRequest req, PathParams pathParams, UrlParams urlParams) {
    var params = Params()
      ..authorIdParam = pathParams.getString("authorId")
      ..bookIdParam = pathParams.getString("bookId");

    parseForm(req, QuoteFormParser(false, false))
        .then((form) => Tuple2(form, params))
        .then((tuple2) => Tuple2(tuple2.e1, tuple2.e2.validate()))
        .then((tuple2) => fromForm(tuple2.e2, tuple2.e1))
        .then((quote) => _quoteService.save(quote))
        .then((quote) => created(quote, req))
        .catchError((e) => handleErrors(e, req));
  }

  Quote fromForm(Params params, QuoteForm form) => Quote(
      null, form.text, params.authorId, params.bookId, nowUtc(), nowUtc());
}
