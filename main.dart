import 'dart:async';
import 'dart:io';

import './handler/common.dart';
import './handler/list_quotes.dart';
import './handler/add_quote.dart';
import './handler/update_quote.dart';
import './handler/delete_quote.dart';
import './handler/get_quote.dart';
import './handler/not_found.dart';

import './service/quote_service.dart';
import './repository/quotes.dart';

Future main() async {
  var  repository = new QuotesRepository();

  var  quotesService = new QuotesService(repository);

  var notFoundHandler = new NotFoundHandler();

  var listQuotesHandler = new ListQuotesHandler(quotesService);
  var addQuoteHandler = new AddQuoteHandler(quotesService);
  var updateQuoteHandler = new UpdateQuoteHandler(quotesService);
  var deleteQuoteHandler = new DeleteQuoteHandler(quotesService);
  var getQuoteHandler = new GetQuoteHandler(quotesService);

  var handlers = [
    listQuotesHandler,
    addQuoteHandler,
    updateQuoteHandler,
    deleteQuoteHandler,
    getQuoteHandler
  ];

  HttpServer server = await HttpServer.bind(InternetAddress.loopbackIPv4, 5050);

  await for (HttpRequest request in server) {
    var found = false;

    for (Handler handler in handlers) {
      if (handler.canHandle(request.uri.path, request.method)) {
        handler.execute(request);
        found = true;
        break;
      }
    }

    if (!found) {
      notFoundHandler.execute(request);
    }
  }
}
