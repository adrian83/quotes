import 'dart:async';
import 'dart:io';

import 'package:logging/logging.dart';

import 'package:quotes_backend/web/server.dart';
import 'package:quotes_backend/web/handler.dart';
import 'package:quotes_backend/domain/author/model/entity.dart';
import 'package:quotes_backend/domain/author/repository.dart';
import 'package:quotes_backend/domain/author/service.dart';
import 'package:quotes_backend/domain/book/model/entity.dart';
import 'package:quotes_backend/domain/book/repository.dart';
import 'package:quotes_backend/domain/book/service.dart';
import 'package:quotes_backend/domain/quote/model/entity.dart';
import 'package:quotes_backend/domain/quote/repository.dart';
import 'package:quotes_backend/domain/quote/service.dart';
import 'package:quotes_backend/domain/web/author/controller.dart';
import 'package:quotes_backend/domain/web/book/controller.dart';
import 'package:quotes_backend/domain/web/quote/controller.dart';
import 'package:quotes_elasticsearch/storage/elasticsearch/store.dart';

const healthCheckPath = "/health";

const storeAllAuthorPath = "/authors";
const searchAllBooksPath = "/books";
const searchAllQuotesPath = "/quotes";

const storeAuthorPath = "/authors";
const searchAuthorsPath = "/authors";
const findAuthorPath = "/authors/{authorId}";
const updateAuthorPath = "/authors/{authorId}";
const deleteAuthorPath = "/authors/{authorId}";
const findAuthorEventsPath = "/authors/{authorId}/events";

const storeBookPath = "$findAuthorPath/books";
const searchBooksPath = "$findAuthorPath/books";
const findBookPath = "$findAuthorPath/books/{bookId}";
const updateBookPath = "$findAuthorPath/books/{bookId}";
const deleteBookPath = "$findAuthorPath/books/{bookId}";
const findBookEventsPath = "$findAuthorPath/books/{bookId}/events";

const storeQuotePath = "$findBookPath/quotes";
const searchQuotesPath = "$findBookPath/quotes";
const findQuotePath = "$findBookPath/quotes/{quoteId}";
const updateQuotePath = "$findBookPath/quotes/{quoteId}";
const deleteQuotePath = "$findBookPath/quotes/{quoteId}";
const findQuoteEventsPath = "$findBookPath/quotes/{quoteId}/events";

class Config {
  final String _defElasticsearchHost = "localhost";
  final String _defElasticsearchPort = "9200";
  final String _defElasticsearchAuthorIndex = "authors";
  final String _defElasticsearchAuthorEventsIndex = "author_events";
  final String _defElasticsearchBookIndex = "books";
  final String _defElasticsearchBookEventsIndex = "book_events";
  final String _defElasticsearchQuotesIndex = "quotes";
  final String _defElasticsearchQuoteEventsIndex = "quote_events";

  String get elasticsearchHost => Platform.environment["ELASTICSEARCH_HOST"] ?? _defElasticsearchHost;

  int get elasticsearchPort => int.parse(Platform.environment["ELASTICSEARCH_PORT"] ?? _defElasticsearchPort);

  String get elasticsearchAuthorIndex => Platform.environment["ELASTICSEARCH_AUTHOR_INDEX"] ?? _defElasticsearchAuthorIndex;

  String get elasticsearchAuthorEventsIndex => Platform.environment["ELASTICSEARCH_AUTHOR_EVENTS_INDEX"] ?? _defElasticsearchAuthorEventsIndex;

  String get elasticsearchBookIndex => Platform.environment["ELASTICSEARCH_BOOK_INDEX"] ?? _defElasticsearchBookIndex;

  String get elasticsearchBookEventsIndex => Platform.environment["ELASTICSEARCH_BOOK_EVENTS_INDEX"] ?? _defElasticsearchBookEventsIndex;

  String get elasticsearchQuotesIndex => Platform.environment["ELASTICSEARCH_QUOTE_INDEX"] ?? _defElasticsearchQuotesIndex;

  String get elasticsearchQuoteEventsIndex => Platform.environment["ELASTICSEARCH_QUOTE_EVENTS_INDEX"] ?? _defElasticsearchQuoteEventsIndex;
}

Future<void> main() async {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.loggerName}: ${rec.level.name}: ${rec.time}: ${rec.message}');
  });

  Config config = Config();

  var elasticsearchHost = config.elasticsearchHost;
  var elasticsearchPort = config.elasticsearchPort;
  var authorIndex = config.elasticsearchAuthorIndex;
  var authorEventsIndex = config.elasticsearchAuthorEventsIndex;
  var bookIndex = config.elasticsearchBookIndex;
  var bookEventsIndex = config.elasticsearchBookEventsIndex;
  var quoteIndex = config.elasticsearchQuotesIndex;
  var quoteEventsIndex = config.elasticsearchQuoteEventsIndex;

  HttpClient client = HttpClient();

  var authorEsStore = ESStore<AuthorDocument>(client, elasticsearchHost, elasticsearchPort, authorIndex);
  var authorEventsEsStore = ESStore<AuthorEvent>(client, elasticsearchHost, elasticsearchPort, authorEventsIndex);
  var bookEsStore = ESStore<BookDocument>(client, elasticsearchHost, elasticsearchPort, bookIndex);
  var bookEventsEsStore = ESStore<BookEvent>(client, elasticsearchHost, elasticsearchPort, bookEventsIndex);
  var quoteEsStore = ESStore<QuoteDocument>(client, elasticsearchHost, elasticsearchPort, quoteIndex);
  var quoteEventsEsStore = ESStore<QuoteEvent>(client, elasticsearchHost, elasticsearchPort, quoteEventsIndex);

  var authorRepository = AuthorRepository(authorEsStore);
  var authorEventsRepository = AuthorEventRepository(authorEventsEsStore);
  var bookRepository = BookRepository(bookEsStore);
  var bookEventsRepository = BookEventRepository(bookEventsEsStore);
  var quoteRepository = QuoteRepository(quoteEsStore);
  var quoteEventsRepository = QuoteEventRepository(quoteEventsEsStore);

  var authorService = AuthorService(
    authorRepository,
    authorEventsRepository,
    bookRepository,
    bookEventsRepository,
    quoteRepository,
    quoteEventsRepository,
  );
  var bookService = BookService(
    bookRepository,
    bookEventsRepository,
    quoteRepository,
    quoteEventsRepository,
  );
  var quoteService = QuoteService(quoteRepository, quoteEventsRepository);

  var authorCtrl = AuthorController(authorService);
  var bookCtrl = BookController(bookService);
  var quoteCtrl = QuoteController(quoteService);

  var healthMapping = Mapping(HttpMethod.get, healthCheckPath, healthHandler);

  var storeAuthorMapping = Mapping(HttpMethod.post, storeAuthorPath, authorCtrl.store);
  var searchAuthorsMapping = Mapping(HttpMethod.get, searchAuthorsPath, authorCtrl.search);
  var findAuthorMapping = Mapping(HttpMethod.get, findAuthorPath, authorCtrl.find);
  var updateAuthorMapping = Mapping(HttpMethod.put, updateAuthorPath, authorCtrl.update);
  var deleteAuthorMapping = Mapping(HttpMethod.delete, deleteAuthorPath, authorCtrl.delete);
  var findAuthorEventsMapping = Mapping(HttpMethod.get, findAuthorEventsPath, authorCtrl.listEvents);

  var storeBookMapping = Mapping(HttpMethod.post, storeBookPath, bookCtrl.store);
  var searchAllBooksMapping = Mapping(HttpMethod.get, searchAllBooksPath, bookCtrl.search);
  var searchAuthorBooksMapping = Mapping(HttpMethod.get, searchBooksPath, bookCtrl.searchAuthorBooks);
  var findBooksMapping = Mapping(HttpMethod.get, findBookPath, bookCtrl.find);
  var updateBooksMapping = Mapping(HttpMethod.put, updateBookPath, bookCtrl.update);
  var deleteBookMapping = Mapping(HttpMethod.delete, deleteBookPath, bookCtrl.delete);
  var findBookEventsMapping = Mapping(HttpMethod.get, findBookEventsPath, bookCtrl.listEvents);

  var storeQuoteMapping = Mapping(HttpMethod.post, storeQuotePath, quoteCtrl.store);
  var searchAllQuotesMapping = Mapping(HttpMethod.get, searchAllQuotesPath, quoteCtrl.search);
  var searchBookQuoteMapping = Mapping(HttpMethod.get, searchQuotesPath, quoteCtrl.searchBookQuotes);
  var findQuotesMapping = Mapping(HttpMethod.get, findQuotePath, quoteCtrl.find);
  var updateQuotesMapping = Mapping(HttpMethod.put, updateQuotePath, quoteCtrl.update);
  var deleteQuoteMapping = Mapping(HttpMethod.delete, deleteQuotePath, quoteCtrl.delete);
  var findQuoteEventsMapping = Mapping(HttpMethod.get, findQuoteEventsPath, quoteCtrl.listEvents);

  var server = Server(
    5050,
    [
      healthMapping,
      storeAuthorMapping,
      searchAuthorsMapping,
      findAuthorMapping,
      updateAuthorMapping,
      deleteAuthorMapping,
      findAuthorEventsMapping,
      storeBookMapping,
      searchAllBooksMapping,
      searchAuthorBooksMapping,
      updateBooksMapping,
      findBooksMapping,
      deleteBookMapping,
      findBookEventsMapping,
      storeQuoteMapping,
      searchAllQuotesMapping,
      searchBookQuoteMapping,
      updateQuotesMapping,
      findQuotesMapping,
      deleteQuoteMapping,
      findQuoteEventsMapping,
    ],
    true,
  );

  server.start();
}
