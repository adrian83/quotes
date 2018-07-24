import 'dart:io';
import 'dart:convert';

import './common.dart';
import '../service/quote_service.dart';
import '../form/quote.dart';
import '../form/common.dart';
import '../domain/quote.dart';

class UpdateQuoteHandler extends Handler {
  QuotesService _quotesService;

  UpdateQuoteHandler(QuotesService quotesService)
      : super(r"/quotes/(\w+)[/]?", "PUT") {
    this._quotesService = quotesService;
  }

  void execute(HttpRequest request) async {
    String content = await request.transform(utf8.decoder).join();
    var data = jsonDecode(content) as Map;

    var formParser = new QuoteFormParser();
    var formResult = formParser.parse(data);

    if (formResult.hasErrors()) {
      badRequest(formResult.errors, request);
      return;
    }

    var pathParser = new PathParser(request.requestedUri.pathSegments);
    var pathResult = pathParser.parse({"quoteId": 1});
    var idOrErr = pathResult.getInt("quoteId");
    if (idOrErr.hasError()) {
      badRequest([idOrErr.error], request);
      return;
    }

    var quote = formToQuote(formResult.form, idOrErr.value);
    var saved = _quotesService.update(quote);
    ok(saved, request);
  }

  Quote formToQuote(QuoteForm form, int quoteId) {
    return new Quote(quoteId, form.txt);
  }
}
