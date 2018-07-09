import 'dart:async';
import 'dart:io';
import 'dart:convert';

import './common.dart';
import '../service/quote_service.dart';

class ListQuotesHandler extends Handler {
  QuotesService _quotesService;
  ListQuotesHandler(QuotesService quotesService) : super("/quotes", "GET") {
    this._quotesService = quotesService;
  }

  void execute(HttpRequest request) {
    var quotes = _quotesService.findQuotes();
    var st = JSON.encode(quotes);

    request.response
      ..write(st)
      ..close();
  }
}
