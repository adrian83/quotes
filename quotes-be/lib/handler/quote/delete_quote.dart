import 'dart:async';
import 'dart:io';

import '../../domain/quote/service.dart';
import '../common.dart';
import '../common/form.dart';
import '../response.dart';
import '../error_handler.dart';
import 'params.dart';

class DeleteQuoteHandler extends Handler {
  QuoteService _quoteService;

  DeleteQuoteHandler(this._quoteService) : super();

  void execute(HttpRequest req, PathParams pathParams, UrlParams urlParams) =>
      Future.value(QuoteIdParams(pathParams.getString("authorId"),
              pathParams.getString("bookId"), pathParams.getString("quoteId")))
          .then((params) => params.validate())
          .then((params) => _quoteService.delete(params.quoteId))
          .then((_) => ok(null, req))
          .catchError((e) => handleErrors(e, req));
}
