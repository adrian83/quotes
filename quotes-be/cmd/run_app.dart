import 'dart:async';
import 'dart:io';

import './common.dart';

import '../config/config.dart';

import '../handler/router.dart';
import '../handler/not_found.dart';
import '../handler/options.dart';
import '../handler/quote/list_quotes.dart';
import '../handler/quote/add_quote.dart';
import '../handler/quote/update_quote.dart';
import '../handler/quote/delete_quote.dart';
import '../handler/quote/get_quote.dart';
import '../handler/quote/list_events.dart';
import '../handler/quote/find_quotes.dart';

import '../handler/author/find_authors.dart';
import '../handler/author/add_author.dart';
import '../handler/author/update_author.dart';
import '../handler/author/get_author.dart';
import '../handler/author/delete_author.dart';
import '../handler/author/list_events.dart';

import '../handler/book/list_books.dart';
import '../handler/book/add_book.dart';
import '../handler/book/delete_book.dart';
import '../handler/book/get_book.dart';
import '../handler/book/update_book.dart';
import '../handler/book/list_events.dart';
import '../handler/book/find_books.dart';

import '../domain/author/service.dart';
import '../domain/quote/service.dart';
import '../domain/book/service.dart';

import './run_populate.dart';

Future main(List<String> args) async {
  if (args.length == 0) {
    print("Please provide config location as a first command parameter");
    exit(1);
  }

  if(args.length == 2){
    await populate(args[0]);
  }

  initLogger();

  Config config = await readConfig(args[0]);

  var connection = await createConnection(config.postgres);

  var repositories = createRepositories(connection);
  var eventRepositories = await createEventRepositories(config.elasticsearch);
  var services = createServices(repositories, eventRepositories);

  var router = createRouter(services.authorService, services.bookService, services.quoteService);

  HttpServer server = await HttpServer.bind("0.0.0.0", 5050);

  await for (HttpRequest request in server) {
    router.handleRequest(request);
  }
}

Router createRouter(AuthorService authorService, BookService bookService,
    QuoteService quoteService) {
  var notFoundHandler = NotFoundHandler();
  var optionsHandler = OptionsHandler();

  var addAuthorHandler = AddAuthorHandler(authorService);
  var findAuthorsHandler = FindAuthorsHandler(authorService);
  var getAuthorHandler = GetAuthorHandler(authorService);
  var updateAuthorHandler = UpdateAuthorHandler(authorService);
  var deleteAuthorHandler = DeleteAuthorHandler(authorService);
  var authorEventsHandler = AuthorEventsHandler(authorService);

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

  Router router = Router();

  router.notFoundHandler = notFoundHandler;

  router.registerRoute(r"/{anything}", "OPTIONS", optionsHandler);

  router.registerRoute(r"/authors", "POST", addAuthorHandler);
  router.registerRoute(r"/authors/{authorId}", "GET", getAuthorHandler);
  router.registerRoute(r"/authors/{authorId}", "PUT", updateAuthorHandler);
  router.registerRoute(r"/authors/{authorId}", "DELETE", deleteAuthorHandler);
  router.registerRoute(r"/authors", "GET", findAuthorsHandler);
  router.registerRoute(r"/authors/{authorId}/events", "GET", authorEventsHandler);

  router.registerRoute(r"/authors/{authorId}/books", "POST", addBookHandler);
  router.registerRoute(r"/authors/{authorId}/books/{bookId}", "GET", getBookHandler);
  router.registerRoute(r"/authors/{authorId}/books/{bookId}", "PUT", updateBookHandler);
  router.registerRoute(r"/authors/{authorId}/books/{bookId}", "DELETE", deleteBookHandler);
  router.registerRoute(r"/authors/{authorId}/books", "GET", listBooksHandler);
  router.registerRoute(r"/books", "GET", findBooksHandler);
  router.registerRoute(r"/authors/{authorId}/books/{bookId}/events", "GET", bookEventsHandler);

  router.registerRoute(r"/authors/{authorId}/books/{bookId}/quotes", "POST", addQuoteHandler);
  router.registerRoute(r"/authors/{authorId}/books/{bookId}/quotes/{quoteId}", "GET", getQuoteHandler);
  router.registerRoute(r"/authors/{authorId}/books/{bookId}/quotes/{quoteId}", "PUT", updateQuoteHandler);
  router.registerRoute(r"/authors/{authorId}/books/{bookId}/quotes/{quoteId}", "DELETE", deleteQuoteHandler);
  router.registerRoute(r"/authors/{authorId}/books/{bookId}/quotes", "GET", listQuotesHandler);
  router.registerRoute(r"/quotes", "GET", findQuotesHandler);
  router.registerRoute(r"/authors/{authorId}/books/{bookId}/quotes/{quoteId}/events", "GET", quoteEventsHandler);
  return router;
}
