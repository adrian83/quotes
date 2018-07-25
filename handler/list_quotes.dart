import 'dart:io';

import './common.dart';
import '../service/quote_service.dart';

class ListQuotesHandler extends Handler {
  QuotesService _quotesService;

  ListQuotesHandler(QuotesService quotesService)
      : super(r"/quotes[/]?$", "GET") {
    this._quotesService = quotesService;
  }

  void execute(HttpRequest request) {
    var quotes = _quotesService.findQuotes();
    ok(quotes, request);
  }
}
