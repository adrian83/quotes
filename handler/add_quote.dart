import 'dart:async';
import 'dart:io';
import 'dart:convert';

import './common.dart';
import '../service/quote_service.dart';

class AddQuoteHandler extends Handler {
  QuotesService _quotesService;

  AddQuoteHandler(QuotesService quotesService) : super("/quotes", "POST") {
    this._quotesService = quotesService;
  }

  void execute(HttpRequest request) async {

        String content = await request.transform(utf8.decoder).join(); 
        var data = jsonDecode(content) as Map; 


    request.response
      ..write(data.toString())
      ..close();
  }
}
