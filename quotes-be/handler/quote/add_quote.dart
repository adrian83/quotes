import 'dart:io';
import 'dart:convert';

import './../common.dart';
import '../../service/quote_service.dart';
import '../../form/quote.dart';
import '../../domain/quote.dart';

class AddQuoteHandler extends Handler {
  final _URL = r"/quotes[/]?";

  QuotesService _quotesService;

  AddQuoteHandler(this._quotesService) : super(_URL, "POST");

  void execute(HttpRequest request) async {
    var result = await parseForm(request, new QuoteFormParser());
    if (result.hasErrors()) {
      badRequest(result.errors, request);
      return;
    }

    var quote = formToQuote(result.form);
    var saved = _quotesService.save(quote);
    created(saved, request);
  }

  Quote formToQuote(QuoteForm form) {
    return new Quote(null, form.txt, form.language);
  }
}
