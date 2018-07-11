import 'dart:async';
import 'dart:io';
import 'dart:convert';

import './common.dart';
import '../service/quote_service.dart';
import '../form/common.dart';

class AddQuoteHandler extends Handler {
  QuotesService _quotesService;

  AddQuoteHandler(QuotesService quotesService) : super("/quotes", "POST") {
    this._quotesService = quotesService;
  }

  void execute(HttpRequest request) async {
    String content = await request.transform(utf8.decoder).join();
    var data = jsonDecode(content) as Map;

    var parser = new QuoteFormParser();
    var result = parser.parse(data);

    if (result.hasErrors()) {
      // 400 bad request
      request.response
        ..write(JSON.encode(result.errors))
        ..close();
    } else {
      request.response
        ..write(JSON.encode(result.form))
        ..close();
    }
  }
}
