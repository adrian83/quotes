import 'dart:io';
import 'dart:convert';

import './common.dart';
import '../service/quote_service.dart';
import '../form/quote.dart';
import '../domain/quote.dart';

class AddQuoteHandler extends Handler {
  QuotesService _quotesService;

  AddQuoteHandler(QuotesService quotesService) : super(r"/quotes[/]?", "POST") {
    this._quotesService = quotesService;
  }

  void execute(HttpRequest request) async {
    String content = await request.transform(utf8.decoder).join();
    var data = jsonDecode(content) as Map;

    var parser = new QuoteFormParser();
    var result = parser.parse(data);

    if (result.hasErrors()) {
      badRequest(result.errors, request);
    } else {
      var quote = formToQuote(result.form);
      var saved = _quotesService.save(quote);
      created(saved, request);
    }
  }

  Quote formToQuote(QuoteForm form) {
    return new Quote(null, form.txt);
  }
}
