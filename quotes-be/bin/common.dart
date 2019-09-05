import 'dart:async';
import 'dart:io';

import 'package:logging/logging.dart';
import 'package:postgres/postgres.dart';

import '../lib/domain/author/repository.dart';
import '../lib/domain/quote/repository.dart';
import '../lib/domain/book/repository.dart';

import '../lib/domain/author/event.dart';
import '../lib/domain/quote/event.dart';
import '../lib/domain/book/event.dart';

import '../lib/domain/author/model.dart';
import '../lib/domain/quote/model.dart';
import '../lib/domain/book/model.dart';

import '../lib/domain/author/service.dart';
import '../lib/domain/quote/service.dart';
import '../lib/domain/book/service.dart';

import '../lib/config/config.dart';

import '../lib/internal/elasticsearch/store.dart';

class Repositories {
  AuthorRepository _authorRepository;
  BookRepository _bookRepository;
  QuoteRepository _quoteRepository;

  Repositories(
      this._authorRepository, this._bookRepository, this._quoteRepository);

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

  EventRepositories(
      this._authorRepository, this._bookRepository, this._quoteRepository);

  AuthorEventRepository get authorRepository => _authorRepository;
  BookEventRepository get bookRepository => _bookRepository;
  QuoteEventRepository get quoteRepository => _quoteRepository;
}

Future<EventRepositories> createEventRepositories(
    ElasticsearchConfig config) async {
  HttpClient client = HttpClient();

  var host = config.host;
  var port = config.port;

  var authorEs = ESStore<AuthorEvent>(client, host, port, config.authorsIndex);
  var bookEs = ESStore<BookEvent>(client, host, port, config.booksIndex);
  var quoteEs = ESStore<QuoteEvent>(client, host, port, config.quotesIndex);

  var authorEventRepo = AuthorEventRepository(authorEs);
  var bookEventRepo = BookEventRepository(bookEs);
  var quoteEventRepo = QuoteEventRepository(quoteEs);

  for (var i = 0; i < 10; i++) {
    var active = await authorEs.active().catchError((_) => false);

    if (active) {
      return EventRepositories(authorEventRepo, bookEventRepo, quoteEventRepo);
    }

    sleep(Duration(seconds: config.reconnectDelaySec));
  }

  throw ArgumentError("cannot create PostgreSQLConnection");
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

Services createServices(
    Repositories repositories, EventRepositories eventRepositories) {
  var authorService = AuthorService(
      repositories.authorRepository,
      eventRepositories.authorRepository,
      repositories.bookRepository,
      eventRepositories.bookRepository,
      repositories.quoteRepository,
      eventRepositories.quoteRepository);

  var bookService = BookService(
      repositories.bookRepository,
      eventRepositories.bookRepository,
      repositories.quoteRepository,
      eventRepositories.quoteRepository);

  var quoteService = QuoteService(
      repositories.quoteRepository, eventRepositories.quoteRepository);

  return Services(authorService, bookService, quoteService);
}

void initLogger() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.loggerName}: ${rec.level.name}: ${rec.time}: ${rec.message}');
  });
}

// dummy version of waithing for infrastructure to initialize
// TODO: make it better
Future<PostgreSQLConnection> createConnection(PostgresConfig config) async {
  for (var i = 0; i < 10; i++) {
    PostgreSQLConnection connection = PostgreSQLConnection(
        config.host, config.port, config.database,
        username: config.user, password: config.password);

    var connected =
        await connection.open().then((_) => true).catchError((_) => false);

    if (connected) {
      return connection;
    }

    sleep(Duration(seconds: config.reconnectDelaySec));
  }

  throw ArgumentError("cannot create PostgreSQLConnection");
}
