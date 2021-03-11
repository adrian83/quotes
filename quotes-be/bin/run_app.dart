import 'dart:async';
import 'dart:io';

import 'package:logging/logging.dart';

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

  var repositories = createRepositories(config.elasticsearch);
  var services = createServices(repositories);

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

  Router router = Router(resourceNotFound);

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

class Repositories {
  AuthorRepository authorRepository;
  BookRepository bookRepository;
  QuoteRepository quoteRepository;
  AuthorEventRepository authorEventsRepository;
  BookEventRepository bookEventsRepository;
  QuoteEventRepository quoteEventsRepository;

  Repositories(
      this.authorRepository, this.bookRepository, this.quoteRepository, this.authorEventsRepository, this.bookEventsRepository, this.quoteEventsRepository);
}

Repositories createRepositories(ElasticsearchConfig config) {
  HttpClient client = HttpClient();

  var host = config.host;
  var port = config.port;

  var author = ESStore<Author>(client, host, port, config.authorsIndex);
  var book = ESStore<Book>(client, host, port, config.booksIndex);
  var quote = ESStore<Quote>(client, host, port, config.quotesIndex);
  var authorEs = ESStore<AuthorEvent>(client, host, port, config.authorEventsIndex);
  var bookEs = ESStore<BookEvent>(client, host, port, config.bookEventsIndex);
  var quoteEs = ESStore<QuoteEvent>(client, host, port, config.quoteEventsIndex);

  var authorRepo = AuthorRepository(author);
  var bookRepo = BookRepository(book);
  var quoteRepo = QuoteRepository(quote);
  var authorEventRepo = AuthorEventRepository(authorEs);
  var bookEventRepo = BookEventRepository(bookEs);
  var quoteEventRepo = QuoteEventRepository(quoteEs);

  return Repositories(authorRepo, bookRepo, quoteRepo, authorEventRepo, bookEventRepo, quoteEventRepo);
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

Services createServices(Repositories repositories) {
  var authorService = AuthorService(repositories.authorRepository, repositories.authorEventsRepository, repositories.bookRepository,
      repositories.bookEventsRepository, repositories.quoteRepository, repositories.quoteEventsRepository);

  var bookService =
      BookService(repositories.bookRepository, repositories.bookEventsRepository, repositories.quoteRepository, repositories.quoteEventsRepository);

  var quoteService = QuoteService(repositories.quoteRepository, repositories.quoteEventsRepository);

  return Services(authorService, bookService, quoteService);
}
