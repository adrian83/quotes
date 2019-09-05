import 'dart:io';

import '../../domain/quote/model.dart';
import '../../domain/quote/service.dart';
import '../../common/tuple.dart';
import '../common.dart';
import '../common/form.dart';
import '../response.dart';
import '../error_handler.dart';
import '../form.dart';
import 'form.dart';
import '../book/params.dart';
import '../../common/time.dart';

class AddQuoteHandler extends Handler {
  QuoteService _quoteService;

  AddQuoteHandler(this._quoteService) : super();

  void execute(HttpRequest req, PathParams pathParams, UrlParams urlParams) =>
      parseForm(req, QuoteFormParser(false, false))
          .then((form) => Tuple2(
              form,
              BookIdParams(pathParams.getString("authorId"),
                  pathParams.getString("bookId"))))
          .then((tuple2) => Tuple2(tuple2.e1, tuple2.e2.validate()))
          .then((tuple2) => fromForm(tuple2.e2, tuple2.e1))
          .then((quote) => _quoteService.save(quote))
          .then((quote) => created(quote, req))
          .catchError((e) => handleErrors(e, req));

  Quote fromForm(BookIdValidParams params, QuoteForm form) => Quote(
      null, form.text, params.authorId, params.bookId, nowUtc(), nowUtc());
}
