import 'dart:async';
import 'dart:io';

import '../../domain/common/model.dart';
import '../../domain/quote/service.dart';
import '../common.dart';
import '../common/form.dart';
import '../book/params.dart';

class ListQuotesHandler extends Handler {
  QuoteService _quoteService;

  ListQuotesHandler(this._quoteService) : super();

  void execute(HttpRequest req, PathParams pathParams, UrlParams urlParams) => Future.value(ListByBookParams(
          pathParams.getString("authorId"),
          pathParams.getString("bookId"),
          urlParams.getIntOrElse("limit", 2),
          urlParams.getIntOrElse("offset", 0)))
      .then((params) => params.validate())
      .then((params) => _quoteService.findBookQuotes(params.bookId, PageRequest(params.limit, params.offset)))
      .then((p) => ok(p, req))
      .catchError((e) => handleErrors(e, req));
}
