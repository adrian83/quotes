import 'dart:async';
import 'dart:io';

import '../../domain/common/model.dart';
import '../../domain/quote/service.dart';
import '../common.dart';
import '../common/form.dart';
import '../common/params.dart';

class ListQuotesHandler extends Handler {
  static final _URL = r"/authors/{authorId}/books/{bookId}/quotes";

  QuoteService _quoteService;

  ListQuotesHandler(this._quoteService) : super(_URL, "GET") {}

  void execute(HttpRequest req, PathParams pathParams, UrlParams urlParams) {
    var params = Params()
      ..authorIdParam = pathParams.getString("authorId")
      ..bookIdParam = pathParams.getString("bookId")
      ..limitParam = urlParams.getIntOrElse("limit", 2)
      ..offsetParam = urlParams.getIntOrElse("offset", 0);

    Future.value(params)
        .then((params) => params.validate())
        .then((params) => _quoteService.findBookQuotes(
            params.bookId, PageRequest(params.limit, params.offset)))
        .then((p) => ok(p, req))
        .catchError((e) => handleErrors(e, req));
  }
}
