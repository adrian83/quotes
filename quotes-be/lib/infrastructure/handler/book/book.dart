import 'dart:io';

import 'package:logging/logging.dart';

import 'form.dart';
import '../error.dart';
import '../../web/form.dart';
import '../../web/param.dart';
import '../../web/response.dart';
import '../../../common/tuple.dart';
import '../../../domain/book/model.dart';
import '../../../domain/book/service.dart';
import '../../../domain/common/model.dart';

// var requiredAuthorId = ParamData("authorId", "authorId cannot be empty");
// var requiredBookId = ParamData("bookId", "bookId cannot be empty");
// var optionalSearchPhrase = ParamData("searchPhrase", "");
// var positivePageLimit = ParamData("limit", "limit should be a positive integer");
// var positivePageOffset = ParamData("offset", "offset should be a positive integer");

class BookHandler {
  static final Logger logger = Logger('BookHandler');

  BookService _bookService;

  BookHandler(this._bookService);

  void persist(HttpRequest req, Params params) => readForm(req)
      .then((form) => PersistBookParams(form, params))
      .then((persistParams) => _bookService.save(persistParams.toBook()))
      .then((book) => created(book, req))
      .catchError((e) => handleErrors(e, req));

  void delete(HttpRequest req, Params params) => Future.value(DeleteBookParams(params))
      .then((deleteParams) => _bookService.delete(deleteParams.getBookId()))
      .then((_) => ok(null, req))
      .catchError((e) => handleErrors(e, req));

  void search(HttpRequest req, Params params) => Future.value(SearchParams(params))
      .then((searchParams) => _bookService.findBooks(searchParams.toSearchEntityRequest()))
      .then((books) => ok(books, req))
      .catchError((e) => handleErrors(e, req));

  void find(HttpRequest req, Params params) => Future.value(FindBookParams(params))
      .then((findParams) => _bookService.find(findParams.getBookId()))
      .then((book) => ok(book, req))
      .catchError((e) => handleErrors(e, req));

  void listByAuthor(HttpRequest req, Params params) => Future.value(ListBooksByAuthorParams(params))
      .then((params) => _bookService.findAuthorBooks(params.toListBooksByAuthorRequest()))
      .then((books) => ok(books, req))
      .catchError((e) => handleErrors(e, req));

  void update(HttpRequest req, Params params) => readForm(req)
      .then((form) => UpdateBookParams(form, params))
      .then((updateParams) => _bookService.update(updateParams.toBook()))
      .then((book) => ok(book, req))
      .catchError((e) => handleErrors(e, req));

  void listEvents(HttpRequest req, Params params) => Future.value(ListEventsByBookParams(params))
      .then((params) => _bookService.listEvents(params.toListEventsByBookRequest()))
      .then((authors) => ok(authors, req))
      .catchError((e) => handleErrors(e, req));
}
