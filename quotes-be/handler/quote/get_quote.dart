import 'dart:io';
import 'dart:convert';

import './../common.dart';
import '../../domain/quote/service.dart';
import '../../domain/quote/form.dart';
import '../../domain/common/form.dart';
import '../../domain/quote/model.dart';

class GetQuoteHandler extends Handler {
  final _URL = r"/authors/{authorId}/books/{bookId}/quotes/{quoteId}";

  QuotesService _quotesService;

  GetQuoteHandler(this._quotesService) : super(_URL, "GET");

  void execute(HttpRequest request) async {
    var pathParsed = parsePath(request.requestedUri.pathSegments);
    var authorIdOrErr = pathParsed.getString("authorId");
    var bookIdOrErr = pathParsed.getString("bookId");
    var quoteIdOrErr = pathParsed.getString("quoteId");

    var errors = ParseElem.errors([authorIdOrErr, bookIdOrErr, quoteIdOrErr]);
    if (errors.length > 0) {
      badRequest(errors, request);
      return;
    }

    var quote = _quotesService.find(authorIdOrErr.value, bookIdOrErr.value, quoteIdOrErr.value);
    if (quote == null) {
      notFound(request);
      return;
    }

    ok(quote, request);
  }
}
