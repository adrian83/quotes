import 'dart:async';
import 'dart:io';

import 'config/config.dart';

import './handler/router.dart';
import './handler/not_found.dart';
import './handler/options.dart';
import './handler/quote/list_quotes.dart';
import './handler/quote/add_quote.dart';
import './handler/quote/update_quote.dart';
import './handler/quote/delete_quote.dart';
import './handler/quote/get_quote.dart';
import './handler/quote/list_events.dart';
import './handler/quote/find_quotes.dart';

import './handler/author/find_authors.dart';
import './handler/author/add_author.dart';
import './handler/author/update_author.dart';
import './handler/author/get_author.dart';
import './handler/author/delete_author.dart';
import './handler/author/list_events.dart';

import './handler/book/list_books.dart';
import './handler/book/add_book.dart';
import './handler/book/delete_book.dart';
import './handler/book/get_book.dart';
import './handler/book/update_book.dart';
import './handler/book/list_events.dart';
import './handler/book/find_books.dart';

import './domain/author/model.dart';
import './domain/author/service.dart';
import './domain/author/event.dart';
import './domain/author/repository.dart';

import './domain/quote/model.dart';
import './domain/quote/service.dart';
import './domain/quote/event.dart';
import './domain/quote/repository.dart';

import './domain/book/model.dart';
import './domain/book/service.dart';
import './domain/book/event.dart';
import './domain/book/repository.dart';

import 'tools/elasticsearch/store.dart';

import 'package:postgres/postgres.dart';
import 'package:logging/logging.dart';

Future main(List<String> args) async {
  if (args.length == 0) {
    print("Please provide config location as a first command parameter");
    exit(1);
  }

  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.loggerName}: ${rec.level.name}: ${rec.time}: ${rec.message}');
  });

  String configLocation = args[0];
  Config config = await readConfig(configLocation);

  var dbConfig = config.postgres;

  PostgreSQLConnection connection = PostgreSQLConnection(
      dbConfig.host, dbConfig.port, dbConfig.database,
      username: dbConfig.user, password: dbConfig.password);
  await connection.open();

  AuthorRepository authorRepository = AuthorRepository(connection);
  BookRepository bookRepository = BookRepository(connection);
  QuoteRepository quoteRepository = QuoteRepository(connection);

  HttpClient client = HttpClient();

  var esConfig = config.elasticsearch;

  var authorEsStore = ESStore<AuthorEvent>(
      client, esConfig.host, esConfig.port, esConfig.authorsIndex);

  var bookEsStore = ESStore<BookEvent>(
      client, esConfig.host, esConfig.port, esConfig.booksIndex);

  var quoteEsStore = ESStore<QuoteEvent>(
      client, esConfig.host, esConfig.port, esConfig.quotesIndex);

  var authorEventRepository = AuthorEventRepository(authorEsStore);
  var bookEventRepository = BookEventRepository(bookEsStore);
  var quoteEventRepository = QuoteEventRepository(quoteEsStore);

  var authorService = AuthorService(
      authorRepository,
      authorEventRepository,
      bookRepository,
      bookEventRepository,
      quoteRepository,
      quoteEventRepository);
  var bookService = BookService(bookRepository, bookEventRepository,
      quoteRepository, quoteEventRepository);
  var quoteService = QuoteService(quoteRepository, quoteEventRepository);

  var router = createRouter(authorService, bookService, quoteService);

  HttpServer server = await HttpServer.bind(InternetAddress.loopbackIPv4, 5050);

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
  router.registerRoute(
      r"/authors/{authorId}/events", "GET", authorEventsHandler);

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
