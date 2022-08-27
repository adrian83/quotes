import 'dart:async';
import 'dart:io';

import 'package:logging/logging.dart';

import 'package:quotesbe2/web/server.dart';
import 'package:quotesbe2/web/handler.dart';

import 'package:quotesbe2/domain/author/model.dart';
import 'package:quotesbe2/domain/author/repository.dart';
import 'package:quotesbe2/domain/author/service.dart';

import 'package:quotesbe2/domain/web/author/controller.dart';
import 'package:quotesbe2/domain/web/quote/controller.dart';

import 'package:quotesbe2/storage/elasticsearch/store.dart';


Future<void> main() async {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.loggerName}: ${rec.level.name}: ${rec.time}: ${rec.message}');
  });

  HttpClient client = HttpClient();

  var host = "localhost";
  var port = 9200;
  var authorsIndex = "authors";
  var authorEventsIndex = "author_events";

  var author = ESStore<Author>(client, host, port, authorsIndex);
  var authorEs = ESStore<AuthorEvent>(client, host, port, authorEventsIndex);

  var authorRepo = AuthorRepository(author);
  var authorEventsRepo = AuthorEventRepository(authorEs);

  var authorService = AuthorService(authorRepo, authorEventsRepo);

  var authorController = AuthorController(authorService);
  var quoteController = QuoteController(authorService);

  var healthMapping = Mapping(HttpMethod.get, "/health", healthHandler);

  var storeAuthorMapping =
      Mapping(HttpMethod.post, "/authors", authorController.store);
  var searchAuthorsMapping =
      Mapping(HttpMethod.get, "/authors", authorController.search);




  var findAuthorMapping =
      Mapping(HttpMethod.get, "/authors/{authorId}", authorController.find);
  var updateAuthorMapping =
      Mapping(HttpMethod.put, "/authors/{authorId}", authorController.update);


  var findQuoteMapping = Mapping(
      HttpMethod.get,
      "/authors/{authorId}/books/{bookId}/quotes/{quoteId}",
      quoteController.find,);


  var server = Server(8080,
      [healthMapping, storeAuthorMapping, searchAuthorsMapping, findAuthorMapping, updateAuthorMapping, findQuoteMapping]);
  server.start();
}
