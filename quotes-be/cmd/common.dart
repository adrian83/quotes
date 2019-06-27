import 'dart:async';
import 'dart:io';

import 'package:logging/logging.dart';
import 'package:postgres/postgres.dart';

import '../domain/author/repository.dart';
import '../domain/quote/repository.dart';
import '../domain/book/repository.dart';

import '../domain/author/event.dart';
import '../domain/quote/event.dart';
import '../domain/book/event.dart';

import '../domain/author/model.dart';
import '../domain/quote/model.dart';
import '../domain/book/model.dart';

import '../domain/author/service.dart';
import '../domain/quote/service.dart';
import '../domain/book/service.dart';

import '../config/config.dart';

import '../tools/elasticsearch/store.dart';

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

EventRepositories createEventRepositories(ElasticsearchConfig config) {
  HttpClient client = HttpClient();

  var authorEsStore = ESStore<AuthorEvent>(
      client, config.host, config.port, config.authorsIndex);

  var bookEsStore =
      ESStore<BookEvent>(client, config.host, config.port, config.booksIndex);

  var quoteEsStore =
      ESStore<QuoteEvent>(client, config.host, config.port, config.quotesIndex);

  var authorEventRepository = AuthorEventRepository(authorEsStore);
  var bookEventRepository = BookEventRepository(bookEsStore);
  var quoteEventRepository = QuoteEventRepository(quoteEsStore);

  return EventRepositories(
      authorEventRepository, bookEventRepository, quoteEventRepository);
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

    var error = false;
    await connection.open().catchError((e) {
      print("error $e");
      error = true;
      sleep(Duration(seconds: config.reconnectDelaySec));
    });
    if (!error) {
      return connection;
    }
  }

  throw ArgumentError("cannot create PostgreSQLConnection");
}
