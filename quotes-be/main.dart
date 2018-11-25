import 'dart:async';
import 'dart:io';

import './handler/common.dart';
import './handler/not_found.dart';
import './handler/options.dart';
import './handler/quote/list_quotes.dart';
import './handler/quote/add_quote.dart';
import './handler/quote/update_quote.dart';
import './handler/quote/delete_quote.dart';
import './handler/quote/get_quote.dart';

import './handler/author/list_authors.dart';
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

import './domain/author/model.dart';
import './domain/author/service.dart';
import './domain/author/event_repository.dart';
import './domain/author/repository.dart';

import './domain/quote/model.dart';
import './domain/quote/service.dart';
import './domain/quote/event_repository.dart';
import './domain/quote/repository.dart';

import './domain/book/model.dart';
import './domain/book/service.dart';
import './domain/book/event_repository.dart';
import './domain/book/repository.dart';

import 'store/elasticsearch_store.dart';

import 'package:postgres/postgres.dart';

import 'config/config.dart';

Future main(List<String> args) async {
  if (args.length == 0) {
    print("Please provide config location as a first command parameter");
    exit(1);
  }

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

  var authorService = AuthorService(authorRepository, authorEventRepository,
      bookRepository, bookEventRepository, quoteRepository);
  var bookService = BookService(bookRepository, bookEventRepository);
  var quoteService = QuotesService(quoteRepository);

  var notFoundHandler = NotFoundHandler();
  var optionsHandler = OptionsHandler();

  var addAuthorHandler = AddAuthorHandler(authorService);
  var listAuthorsHandler = ListAuthorsHandler(authorService);
  var getAuthorHandler = GetAuthorHandler(authorService);
  var updateAuthorHandler = UpdateAuthorHandler(authorService);
  var deleteAuthorHandler = DeleteAuthorHandler(authorService);
  var authorEventsHandler = AuthorEventsHandler(authorService);

  var addBookHandler = AddBookHandler(bookService);
  var listBooksHandler = ListBooksHandler(bookService);
  var getBookHandler = GetBookHandler(bookService);
  var updateBookHandler = UpdateBookHandler(bookService);
  var deleteBookHandler = DeleteBookHandler(bookService);

  var addQuoteHandler = AddQuoteHandler(quoteService);
  var listQuotesHandler = ListQuotesHandler(quoteService);
  var getQuoteHandler = GetQuoteHandler(quoteService);
  var updateQuoteHandler = UpdateQuoteHandler(quoteService);
  var deleteQuoteHandler = DeleteQuoteHandler(quoteService);

  var handlers = [
    authorEventsHandler,
    addAuthorHandler,
    getAuthorHandler,
    updateAuthorHandler,
    deleteAuthorHandler,
    listAuthorsHandler,
    addBookHandler,
    getBookHandler,
    updateBookHandler,
    deleteBookHandler,
    listBooksHandler,
    addQuoteHandler,
    getQuoteHandler,
    updateQuoteHandler,
    deleteQuoteHandler,
    listQuotesHandler
  ];

  Author a1 = await authorService
      .save(Author(null, "Adam Mickiewicz", "abc def", DateTime.now().toUtc()));
  Author a2 = await authorService.save(
      Author(null, "Henryk Sienkiewicz", "abc def", DateTime.now().toUtc()));
  Author a3 = await authorService
      .save(Author(null, "Shakespear", "abc def", DateTime.now().toUtc()));

  Book b1 =
      await bookService.save(Book(null, "Dziady", "Description...", a1.id));
  await bookService.save(Book(null, "Pan Tadeusz", "Description...", a1.id));
  await bookService.save(Book(null, "Switez", "Description...", a1.id));

  await bookService.save(Book(null, "Balladyna", "Description...", a2.id));
  await bookService.save(Book(null, "Beniowski", "Description...", a2.id));
  await bookService.save(Book(null, "Kordian", "Description...", a2.id));

  await bookService.save(Book(null, "Hamlet", "Description...", a3.id));
  await bookService.save(Book(null, "Makbet", "Description...", a3.id));
  await bookService.save(Book(null, "Burza", "Description...", a3.id));

  await quoteService
      .save(Quote(null, "Ciemno wszedzie, glucho wszedzie... 1", a1.id, b1.id));
  await quoteService
      .save(Quote(null, "Ciemno wszedzie, glucho wszedzie... 2", a1.id, b1.id));
  await quoteService
      .save(Quote(null, "Ciemno wszedzie, glucho wszedzie... 3", a1.id, b1.id));

  HttpServer server = await HttpServer.bind(InternetAddress.loopbackIPv4, 5050);

  await for (HttpRequest request in server) {
    var found = false;

    for (Handler handler in handlers) {
      if (handler.canHandle(request.uri.path, request.method)) {
        handler.handle(request);
        found = true;
        break;
      }
    }

    if (request.method == "OPTIONS") {
      optionsHandler.handle(request);
      continue;
    }

    if (!found) {
      notFoundHandler.handle(request);
    }
  }
}
