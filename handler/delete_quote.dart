import 'dart:io';

import './common.dart';
import '../service/quote_service.dart';
import '../form/common.dart';

class DeleteQuoteHandler extends Handler {
  QuotesService _quotesService;

  DeleteQuoteHandler(QuotesService quotesService)
      : super(r"/quotes/(\w+)[/]?", "DELETE") {
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

    _quotesService.delete(idOrErr.value);
    ok(null, request);
  }
}
