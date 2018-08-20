import 'dart:io';
import 'dart:convert';

import './../common.dart';
import '../../service/quote_service.dart';
import '../../form/quote.dart';
import '../../form/common.dart';
import '../../domain/quote.dart';

class UpdateQuoteHandler extends Handler {
  final _URL = r"/quotes/(\w+)[/]?";

  QuotesService _quotesService;

  UpdateQuoteHandler(this._quotesService) : super(_URL, "PUT") {}

  void execute(HttpRequest request) async {
    var parsedForm = await parseForm(request, new QuoteFormParser());
    if (parsedForm.hasErrors()) {
      badRequest(parsedForm.errors, request);
      return;
    }

    var pathParser = new PathParser(request.requestedUri.pathSegments);
    var pathResult = pathParser.parse({"quoteId": 1});
    var idOrErr = pathResult.getString("quoteId");

    if (idOrErr.hasError()) {
      badRequest([idOrErr.error], request);
      return;
    }

    var quote = formToQuote(parsedForm.form, idOrErr.value);
    var saved = _quotesService.update(quote);
    ok(saved, request);
  }

  Quote formToQuote(QuoteForm form, String quoteId) {
    return new Quote(quoteId, form.txt, form.language);
  }
}
