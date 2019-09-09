import 'dart:async';
import 'dart:io';

import './common.dart';

import '../lib/config/config.dart';

import '../lib/handler/router.dart';
import '../lib/handler/handler.dart';


import '../lib/handler/author/author.dart';
import '../lib/handler/book/book.dart';
import '../lib/handler/quote/quote.dart';

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

  var authorHandler = AuthorHandler(authorService);
  var bookHandler = BookHandler(bookService);
  var quoteHandler = QuoteHandler(quoteService);

  Router router = Router();

  router.notFoundHandler = resourceNotFound;

  router.registerRoute(r"/{anything}", "OPTIONS", options);

  router.registerRoute(r"/authors", "POST", authorHandler.persist);
  router.registerRoute(r"/authors/{authorId}", "GET", authorHandler.find);
  router.registerRoute(r"/authors/{authorId}", "PUT", authorHandler.update);
  router.registerRoute(r"/authors/{authorId}", "DELETE", authorHandler.delete);
  router.registerRoute(r"/authors", "GET", authorHandler.search);
  router.registerRoute(r"/authors/{authorId}/events", "GET", authorHandler.listEvents);

  router.registerRoute(r"/authors/{authorId}/books", "POST", bookHandler.persist);
  router.registerRoute(r"/authors/{authorId}/books/{bookId}", "GET", bookHandler.find);
  router.registerRoute(r"/authors/{authorId}/books/{bookId}", "PUT", bookHandler.update);
  router.registerRoute(r"/authors/{authorId}/books/{bookId}", "DELETE", bookHandler.delete);
  router.registerRoute(r"/authors/{authorId}/books", "GET", bookHandler.listByAuthor);
  router.registerRoute(r"/books", "GET", bookHandler.search);
  router.registerRoute(r"/authors/{authorId}/books/{bookId}/events", "GET", bookHandler.listEvents);

  router.registerRoute(r"/authors/{authorId}/books/{bookId}/quotes", "POST", quoteHandler.persist);
  router.registerRoute(r"/authors/{authorId}/books/{bookId}/quotes/{quoteId}", "GET", quoteHandler.find);
  router.registerRoute(r"/authors/{authorId}/books/{bookId}/quotes/{quoteId}", "PUT", quoteHandler.update);
  router.registerRoute(r"/authors/{authorId}/books/{bookId}/quotes/{quoteId}", "DELETE", quoteHandler.delete);
  router.registerRoute(r"/authors/{authorId}/books/{bookId}/quotes", "GET", quoteHandler.listByBook);
  router.registerRoute(r"/quotes", "GET", quoteHandler.search);
  router.registerRoute(r"/authors/{authorId}/books/{bookId}/quotes/{quoteId}/events", "GET", quoteHandler.listEvents);

  return router;
}
