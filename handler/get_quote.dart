import 'dart:io';
import 'dart:convert';

import './common.dart';
import '../service/quote_service.dart';
import '../form/quote.dart';
import '../form/common.dart';
import '../domain/quote.dart';

class GetQuoteHandler extends Handler {
  QuotesService _quotesService;

  GetQuoteHandler(QuotesService quotesService)
      : super(r"/quotes/(\w+)[/]?", "GET") {
    this._quotesService = quotesService;
  }

  void execute(HttpRequest request) async {
    var pathParser = new PathParser(request.requestedUri.pathSegments);
    var pathResult = pathParser.parse({"quoteId": 1});
    var idOrErr = pathResult.getInt("quoteId");
    if (idOrErr.hasError()) {
      badRequest([idOrErr.error], request);
      return;
    }

    var quote = _quotesService.find(idOrErr.value);
    if (quote == null) {
      notFound(request);
    }
    ok(quote, request);
  }
}
