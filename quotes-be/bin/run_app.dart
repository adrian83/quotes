import 'dart:async';
import 'dart:io';

import 'package:logging/logging.dart';
import 'package:postgres/postgres.dart';

import '../lib/config/config.dart';

import '../lib/domain/author/service.dart';
import '../lib/domain/quote/service.dart';
import '../lib/domain/book/service.dart';

import '../lib/infrastructure/handler/author/author.dart';
import '../lib/infrastructure/handler/book/book.dart';
import '../lib/infrastructure/handler/quote/quote.dart';

import '../lib/infrastructure/web/handler.dart';
import '../lib/infrastructure/web/router.dart';
import '../lib/infrastructure/web/server.dart';

import '../lib/domain/author/repository.dart';
import '../lib/domain/quote/repository.dart';
import '../lib/domain/book/repository.dart';

import '../lib/domain/author/event.dart';
import '../lib/domain/quote/event.dart';
import '../lib/domain/book/event.dart';

import '../lib/domain/author/model.dart';
import '../lib/domain/quote/model.dart';
import '../lib/domain/book/model.dart';

import '../lib/infrastructure/elasticsearch/store.dart';

Future main(List<String> args) async {
  if (args.length == 0) {
    print("Please provide config location as a first command parameter");
    exit(1);
  }

  initLogger();

  Config config = await readConfig(args[0]);

  var connection = await createConnection(config.postgres);

  var repositories = createRepositories(connection);
  var eventRepositories = createEventRepositories(config.elasticsearch);
  var services = createServices(repositories, eventRepositories);

  var router = createRouter(services.authorService, services.bookService, services.quoteService);

  var server = Server(config.server, router);
  server.start();
}

void initLogger() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.loggerName}: ${rec.level.name}: ${rec.time}: ${rec.message}');
  });
}



Router createRouter(AuthorService authorService, BookService bookService, QuoteService quoteService) {
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

Future<PostgreSQLConnection> createConnection(PostgresConfig config) async {

  PostgreSQLConnection connection = PostgreSQLConnection(config.host, 
      config.port, config.database, username: config.user, password: config.password);
  
  await connection.open();

  return connection;
}


class Repositories {
  AuthorRepository _authorRepository;
  BookRepository _bookRepository;
  QuoteRepository _quoteRepository;

  Repositories(this._authorRepository, this._bookRepository, this._quoteRepository);

  AuthorRepository get authorRepository => _authorRepository;
  BookRepository get bookRepository => _bookRepository;
  QuoteRepository get quoteRepository => _quoteRepository;
}

Repositories createRepositories(PostgreSQLConnection connection) {
  AuthorRepository authorRepository = AuthorRepository(connection);
  BookRepository bookRepository = BookRepository(connection);
  QuoteRepository quoteRepository = QuoteRepository(connection);

  return Repositories(authorRepository, bookRepository, quoteRepository);
}

class EventRepositories {
  AuthorEventRepository _authorRepository;
  BookEventRepository _bookRepository;
  QuoteEventRepository _quoteRepository;

  EventRepositories(this._authorRepository, this._bookRepository, this._quoteRepository);

  AuthorEventRepository get authorRepository => _authorRepository;
  BookEventRepository get bookRepository => _bookRepository;
  QuoteEventRepository get quoteRepository => _quoteRepository;
}

EventRepositories createEventRepositories(ElasticsearchConfig config) {
  HttpClient client = HttpClient();

  var host = config.host;
  var port = config.port;

  var authorEs = ESStore<AuthorEvent>(client, host, port, config.authorsIndex);
  var bookEs = ESStore<BookEvent>(client, host, port, config.booksIndex);
  var quoteEs = ESStore<QuoteEvent>(client, host, port, config.quotesIndex);

  var authorEventRepo = AuthorEventRepository(authorEs);
  var bookEventRepo = BookEventRepository(bookEs);
  var quoteEventRepo = QuoteEventRepository(quoteEs);

  return EventRepositories(authorEventRepo, bookEventRepo, quoteEventRepo);
}

class Services {
  AuthorService _authorService;
  BookService _bookService;
  QuoteService _quoteService;

  Services(this._authorService, this._bookService, this._quoteService);

  AuthorService get authorService => _authorService;
  BookService get bookService => _bookService;
  QuoteService get quoteService => _quoteService;
}

Services createServices(Repositories repositories, EventRepositories eventRepositories) {
  var authorService = AuthorService(repositories.authorRepository, eventRepositories.authorRepository, repositories.bookRepository,
      eventRepositories.bookRepository, repositories.quoteRepository, eventRepositories.quoteRepository);

  var bookService = BookService(repositories.bookRepository, eventRepositories.bookRepository, repositories.quoteRepository, eventRepositories.quoteRepository);

  var quoteService = QuoteService(repositories.quoteRepository, eventRepositories.quoteRepository);

  return Services(authorService, bookService, quoteService);
}


