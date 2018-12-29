import 'dart:async';
import 'dart:io';

import '../../domain/common/model.dart';
import '../../domain/quote/service.dart';
import '../common.dart';
import '../common/form.dart';
import '../common/params.dart';

class QuoteEventsHandler extends Handler {
  static final _URL =
      r"/authors/{authorId}/books/{bookId}/quotes/{quoteId}/events";

  QuoteService _quoteService;

  QuoteEventsHandler(this._quoteService) : super(_URL, "GET") {}

  void execute(HttpRequest req, PathParams pathParams, UrlParams urlParams) {
    var params = Params()
      ..authorIdParam = pathParams.getString("authorId")
      ..bookIdParam = pathParams.getString("bookId")
      ..quoteIdParam = pathParams.getString("quoteId")
      ..limitParam = urlParams.getIntOrElse("limit", 2)
      ..offsetParam = urlParams.getIntOrElse("offset", 0);

    Future.value(params)
        .then((params) => params.validate())
        .then((params) => _quoteService.listEvents(
            params.authorId,
            params.bookId,
            params.quoteId,
            PageRequest(params.limit, params.offset)))
        .then((events) => ok(events, req))
        .catchError((e) => handleErrors(e, req));
  }
}
