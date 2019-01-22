import 'dart:async';
import 'dart:io';

import '../../domain/common/model.dart';
import '../../domain/quote/service.dart';
import '../common.dart';
import '../common/form.dart';
import 'params.dart';

class QuoteEventsHandler extends Handler {
  static final _URL =
      r"/authors/{authorId}/books/{bookId}/quotes/{quoteId}/events";

  QuoteService _quoteService;

  QuoteEventsHandler(this._quoteService) : super(_URL, "GET") {}

  void execute(HttpRequest req, PathParams pathParams, UrlParams urlParams) =>
      Future.value(ListByQuoteParams(
              pathParams.getString("authorId"),
              pathParams.getString("bookId"),
              pathParams.getString("quoteId"),
              urlParams.getIntOrElse("limit", 2),
              urlParams.getIntOrElse("offset", 0)))
          .then((params) => params.validate())
          .then((params) => _quoteService.listEvents(
              params.authorId,
              params.bookId,
              params.quoteId,
              PageRequest(params.limit, params.offset)))
          .then((events) => ok(events, req))
          .catchError((e) => handleErrors(e, req));
}
