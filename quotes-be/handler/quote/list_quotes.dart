import 'dart:io';

import './../common.dart';
import '../../service/quote_service.dart';

class ListQuotesHandler extends Handler {
  final _URL = r"/quotes[/]?$";

  QuotesService _quotesService;

  ListQuotesHandler(this._quotesService) : super(_URL, "GET") {}

  void execute(HttpRequest request) {
    var quotes = _quotesService.findQuotes();
    ok(quotes, request);
  }
}
