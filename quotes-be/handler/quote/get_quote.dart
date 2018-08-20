import 'dart:io';
import 'dart:convert';

import './../common.dart';
import '../../service/quote_service.dart';
import '../../form/quote.dart';
import '../../form/common.dart';
import '../../domain/quote.dart';

class GetQuoteHandler extends Handler {
  final _URL = r"/quotes/(\w+)[/]?";

  QuotesService _quotesService;

  GetQuoteHandler(this._quotesService) : super(_URL, "GET");

  void execute(HttpRequest request) async {
    var pathParser = new PathParser(request.requestedUri.pathSegments);
    var pathResult = pathParser.parse({"quoteId": 1});
    var idOrErr = pathResult.getString("quoteId");

    if (idOrErr.hasError()) {
      badRequest([idOrErr.error], request);
      return;
    }

    var quote = _quotesService.find(idOrErr.value);

    if (quote == null) {
      notFound(request);
      return;
    }

    ok(quote, request);
  }
}
