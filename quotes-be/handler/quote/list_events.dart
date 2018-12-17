import 'dart:io';

import '../common.dart';
import '../common/form.dart';
import '../../domain/quote/service.dart';
import '../../domain/common/model.dart';

class QuoteEventsHandler extends Handler {
  static final _URL = r"/authors/{authorId}/books/{bookId}/quotes/{quoteId}/events";

  QuoteService _quoteService;

  QuoteEventsHandler(this._quoteService) : super(_URL, "GET") {}

  void execute(
      HttpRequest request, PathParams pathParams, UrlParams urlParams) {
    var limit = urlParams.getIntOrElse("limit", 2);
    var offset = urlParams.getIntOrElse("offset", 0);

    var authorIdOrErr = pathParams.getString("authorId");
    var bookIdOrErr = pathParams.getString("bookId");
    var quoteIdOrErr = pathParams.getString("quoteId");

    var errors = ParseElem.errors([limit, offset, authorIdOrErr, bookIdOrErr, quoteIdOrErr]);
    if (errors.length > 0) {
      badRequest(errors, request);
      return;
    }

    var req = PageRequest(limit.value, offset.value);

    _quoteService.listEvents(authorIdOrErr.value, bookIdOrErr.value, quoteIdOrErr.value, req)
        .then((events) => ok(events, request))
        .catchError((e) => handleErrors(e, request));
  }
}
