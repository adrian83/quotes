import 'dart:io';

import './../common.dart';
import '../../service/quote_service.dart';
import '../../form/common.dart';

class DeleteQuoteHandler extends Handler {
  final _URL = r"/quotes/(\w+)[/]?";

  QuotesService _quotesService;

  DeleteQuoteHandler(this._quotesService) : super(_URL, "DELETE");

  void execute(HttpRequest request) async {
    var pathParser = new PathParser(request.requestedUri.pathSegments);
    var pathResult = pathParser.parse({"quoteId": 1});
    var idOrErr = pathResult.getString("quoteId");

    if (idOrErr.hasError()) {
      badRequest([idOrErr.error], request);
      return;
    }

    _quotesService.delete(idOrErr.value);
    ok(null, request);
  }
}
