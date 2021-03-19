import 'dart:io';

import 'package:logging/logging.dart';

import 'form.dart';
import '../error.dart';
import '../../../infrastructure/web/form.dart';
import '../../../infrastructure/web/param.dart';
import '../../../infrastructure/web/response.dart';
import '../../../domain/book/service.dart';

class BookHandler {
  static final Logger _logger = Logger('BookHandler');

  BookService _bookService;

  BookHandler(this._bookService);

  void persist(HttpRequest req, Params params) => Future.value(params)
      .then((_) => _logger.info("persist book request with params: $params"))
      .then((_) => readForm(req))
      .then((form) => PersistBookParams(form, params))
      .then((persistParams) => _bookService.save(persistParams.toBook()))
      .then((book) => created(book, req))
      .catchError((e) => handleErrors(e, req));

  void delete(HttpRequest req, Params params) => Future.value(params)
      .then((_) => _logger.info("delete book request with params: $params"))
      .then((_) => DeleteBookParams(params))
      .then((deleteParams) => _bookService.delete(deleteParams.getBookId()))
      .then((_) => ok(null, req))
      .catchError((e) => handleErrors(e, req));

  void search(HttpRequest req, Params params) => Future.value(params)
      .then((_) => _logger.info("search for books request with params: $params"))
      .then((_) => SearchParams(params))
      .then((searchParams) => _bookService.findBooks(searchParams.toSearchEntityRequest()))
      .then((books) => ok(books, req))
      .catchError((e) => handleErrors(e, req));

  void find(HttpRequest req, Params params) => Future.value(params)
      .then((_) => _logger.info("find book request with params: $params"))
      .then((_) => FindBookParams(params))
      .then((findParams) => _bookService.find(findParams.getBookId()))
      .then((book) => ok(book, req))
      .catchError((e) => handleErrors(e, req));

  void listByAuthor(HttpRequest req, Params params) => Future.value(params)
      .then((_) => _logger.info("list books by author request with params: $params"))
      .then((_) => ListBooksByAuthorParams(params))
      .then((params) => _bookService.findAuthorBooks(params.toListBooksByAuthorRequest()))
      .then((books) => ok(books, req))
      .catchError((e) => handleErrors(e, req));

  void update(HttpRequest req, Params params) => Future.value(params)
      .then((_) => _logger.info("update book request with params: $params"))
      .then((_) => readForm(req))
      .then((form) => UpdateBookParams(form, params))
      .then((updateParams) => _bookService.update(updateParams.toBook()))
      .then((book) => ok(book, req))
      .catchError((e) => handleErrors(e, req));

  void listEvents(HttpRequest req, Params params) => Future.value(params)
      .then((_) => _logger.info("list book events request with params: $params"))
      .then((_) => ListEventsByBookParams(params))
      .then((params) => _bookService.listEvents(params.toListEventsByBookRequest()))
      .then((authors) => ok(authors, req))
      .catchError((e) => handleErrors(e, req));
}
