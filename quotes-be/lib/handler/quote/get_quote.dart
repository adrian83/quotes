import 'dart:async';
import 'dart:io';

import '../../domain/quote/service.dart';
import '../common.dart';
import '../common/form.dart';
import '../response.dart';
import '../error_handler.dart';
import 'params.dart';

class GetQuoteHandler extends Handler {
  QuoteService _quoteService;

  GetQuoteHandler(this._quoteService) : super();

  void execute(HttpRequest req, PathParams pathParams, UrlParams urlParams) =>
      Future.value(QuoteIdParams(pathParams.getString("authorId"),
              pathParams.getString("bookId"), pathParams.getString("quoteId")))
          .then((params) => params.validate())
          .then((params) => _quoteService.find(params.quoteId))
          .then((q) => ok(q, req))
          .catchError((e) => handleErrors(e, req));
}
