import 'dart:async';
import 'dart:io';

import './handler/common.dart';
import './handler/list_quotes.dart';
import './handler/add_quote.dart';
import './service/quote_service.dart';

Future main() async {
  QuotesService quotesService = new QuotesService();

  Handler listQuotes = new ListQuotesHandler(quotesService);
  Handler addQuote = new AddQuoteHandler(quotesService);

  List<Handler> handlers = [listQuotes, addQuote];

  HttpServer server = await HttpServer.bind(InternetAddress.loopbackIPv4, 5050);

  await for (HttpRequest request in server) {
    var found = false;

    for (Handler handler in handlers) {
      if (handler.canHandle(request.uri.path, request.method)) {
        handler.execute(request);
        found = true;
        continue;
      }
    }

    if (!found) {
      request.response
        ..write('not found')
        ..close();
    }
  }
}
