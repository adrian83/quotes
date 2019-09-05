import 'dart:async';
import 'dart:io';

import './common.dart';

import '../lib/config/config.dart';

import '../lib/handler/router.dart';
import '../lib/handler/not_found.dart';
import '../lib/handler/options.dart';
import '../lib/handler/quote/list_quotes.dart';
import '../lib/handler/quote/add_quote.dart';
import '../lib/handler/quote/update_quote.dart';
import '../lib/handler/quote/delete_quote.dart';
import '../lib/handler/quote/get_quote.dart';
import '../lib/handler/quote/list_events.dart';
import '../lib/handler/quote/find_quotes.dart';

import '../lib/handler/author/author.dart';

import '../lib/handler/book/list_books.dart';
import '../lib/handler/book/add_book.dart';
import '../lib/handler/book/delete_book.dart';
import '../lib/handler/book/get_book.dart';
import '../lib/handler/book/update_book.dart';
import '../lib/handler/book/list_events.dart';
import '../lib/handler/book/find_books.dart';

import '../lib/domain/author/service.dart';
import '../lib/domain/quote/service.dart';
import '../lib/domain/book/service.dart';

import '../lib/web/server.dart';

import './run_populate.dart';

Future main(List<String> args) async {
  if (args.length == 0) {
    print("Please provide config location as a first command parameter");
    exit(1);
  }

  if (args.length == 2) {
    await populate(args[0]);
  }

  initLogger();

  Config config = await readConfig(args[0]);

  var connection = await createConnection(config.postgres);

  var repositories = createRepositories(connection);
  var eventRepositories = await createEventRepositories(config.elasticsearch);
  var services = createServices(repositories, eventRepositories);

  var router = createRouter(
      services.authorService, services.bookService, services.quoteService);

  var server = Server(config.server, router);
  server.start();
}

Router createRouter(AuthorService authorService, BookService bookService,
    QuoteService quoteService) {
  var notFoundHandler = NotFoundHandler();
  var optionsHandler = OptionsHandler();

  var addBookHandler = AddBookHandler(bookService);
  var listBooksHandler = ListBooksHandler(bookService);
  var getBookHandler = GetBookHandler(bookService);
  var updateBookHandler = UpdateBookHandler(bookService);
  var deleteBookHandler = DeleteBookHandler(bookService);
  var bookEventsHandler = BookEventsHandler(bookService);
  var findBooksHandler = FindBooksHandler(bookService);

  var addQuoteHandler = AddQuoteHandler(quoteService);
  var listQuotesHandler = ListQuotesHandler(quoteService);
  var getQuoteHandler = GetQuoteHandler(quoteService);
  var updateQuoteHandler = UpdateQuoteHandler(quoteService);
  var deleteQuoteHandler = DeleteQuoteHandler(quoteService);
  var quoteEventsHandler = QuoteEventsHandler(quoteService);
  var findQuotesHandler = FindQuotesHandler(quoteService);

  // new
  var authorHandler = AuthorHandler(authorService);

  Router router = Router();

  router.notFoundHandler = notFoundHandler;

  router.registerRoute(r"/{anything}", "OPTIONS", optionsHandler);

  router.registerRouteV2(r"/authors", "POST", authorHandler.persist);
  router.registerRouteV2(r"/authors/{authorId}", "GET", authorHandler.find);
  router.registerRouteV2(r"/authors/{authorId}", "PUT", authorHandler.update);
  router.registerRouteV2(
      r"/authors/{authorId}", "DELETE", authorHandler.delete);
  router.registerRouteV2(r"/authors", "GET", authorHandler.search);
  router.registerRouteV2(
      r"/authors/{authorId}/events", "GET", authorHandler.listEvents);

  router.registerRoute(r"/authors/{authorId}/books", "POST", addBookHandler);
  router.registerRoute(
      r"/authors/{authorId}/books/{bookId}", "GET", getBookHandler);
  router.registerRoute(
      r"/authors/{authorId}/books/{bookId}", "PUT", updateBookHandler);
  router.registerRoute(
      r"/authors/{authorId}/books/{bookId}", "DELETE", deleteBookHandler);
  router.registerRoute(r"/authors/{authorId}/books", "GET", listBooksHandler);
  router.registerRoute(r"/books", "GET", findBooksHandler);
  router.registerRoute(
      r"/authors/{authorId}/books/{bookId}/events", "GET", bookEventsHandler);

  router.registerRoute(
      r"/authors/{authorId}/books/{bookId}/quotes", "POST", addQuoteHandler);
  router.registerRoute(r"/authors/{authorId}/books/{bookId}/quotes/{quoteId}",
      "GET", getQuoteHandler);
  router.registerRoute(r"/authors/{authorId}/books/{bookId}/quotes/{quoteId}",
      "PUT", updateQuoteHandler);
  router.registerRoute(r"/authors/{authorId}/books/{bookId}/quotes/{quoteId}",
      "DELETE", deleteQuoteHandler);
  router.registerRoute(
      r"/authors/{authorId}/books/{bookId}/quotes", "GET", listQuotesHandler);
  router.registerRoute(r"/quotes", "GET", findQuotesHandler);
  router.registerRoute(
      r"/authors/{authorId}/books/{bookId}/quotes/{quoteId}/events",
      "GET",
      quoteEventsHandler);
  return router;
}
