import 'dart:async';
import 'dart:io';

import '../../domain/quote/service.dart';
import '../common.dart';
import '../common/form.dart';
import '../common/params.dart';

class DeleteQuoteHandler extends Handler {
  static final _URL = r"/authors/{authorId}/books/{bookId}/quotes/{quoteId}";

  QuoteService _quoteService;

  DeleteQuoteHandler(this._quoteService) : super(_URL, "DELETE");

  void execute(HttpRequest req, PathParams pathParams, UrlParams urlParams) {
    var params = Params()
      ..authorIdParam = pathParams.getString("authorId")
      ..bookIdParam = pathParams.getString("bookId")
      ..quoteIdParam = pathParams.getString("quoteId");

    Future.value(params)
        .then((params) => params.validate())
        .then((params) => _quoteService.delete(params.quoteId))
        .then((_) => ok(null, req))
        .catchError((e) => handleErrors(e, req));
  }
}
