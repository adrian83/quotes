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

var requiredAuthorId = ParamData("authorId", "authorId cannot be empty");
var requiredBookId = ParamData("bookId", "bookId cannot be empty");
var optionalSearchPhrase = ParamData("searchPhrase", "");
var positivePageLimit = ParamData("limit", "limit should be a positive integer");
var positivePageOffset = ParamData("offset", "offset should be a positive integer");

class BookHandler {
  static final Logger logger = Logger('BookHandler');

  BookService _bookService;

  BookHandler(this._bookService);

  void persist(HttpRequest req, Params params) => parseForm(req, NewBookFormParser())
      .then((form) => Tuple2(form, PathParam1(params, notEmptyString, requiredAuthorId)))
      .then((tuple2) => Tuple2(tuple2.e1, tuple2.e2.transform()))
      .then((tuple2) => formToBook(tuple2.e2, tuple2.e1))
      .then((book) => _bookService.save(book))
      .then((book) => created(book, req))
      .catchError((e) => handleErrors(e, req));

  void delete(HttpRequest req, Params params) => Future.value(PathParam2(params, notEmptyString, requiredAuthorId, notEmptyString, requiredBookId))
      .then((params) => params.transform())
      .then((params) => _bookService.delete(params.e2))
      .then((_) => ok(null, req))
      .catchError((e) => handleErrors(e, req));

  void search(HttpRequest req, Params params) =>
      Future.value(PathParam3(params, optionalString, optionalSearchPhrase, positiveInteger, positivePageLimit, positiveInteger, positivePageOffset))
          .then((params) => params.transform())
          .then((params) => _bookService.findBooks(params.e1, PageRequest(params.e2, params.e3)))
          .then((books) => ok(books, req))
          .catchError((e) => handleErrors(e, req));

  void find(HttpRequest req, Params params) => Future.value(PathParam2(params, notEmptyString, requiredAuthorId, notEmptyString, requiredBookId))
      .then((params) => params.transform())
      .then((params) => _bookService.find(params.e2))
      .then((book) => ok(book, req))
      .catchError((e) => handleErrors(e, req));

  void listByAuthor(HttpRequest req, Params params) =>
      Future.value(PathParam3(params, notEmptyString, requiredAuthorId, positiveInteger, positivePageLimit, positiveInteger, positivePageOffset))
          .then((params) => params.transform())
          .then((params) => _bookService.findAuthorBooks(params.e1, PageRequest(params.e2, params.e3)))
          .then((books) => ok(books, req))
          .catchError((e) => handleErrors(e, req));

  void update(HttpRequest req, Params params) => parseForm(req, NewBookFormParser())
      .then((form) => Tuple2(form, PathParam2(params, notEmptyString, requiredAuthorId, notEmptyString, requiredBookId)))
      .then((tuple2) => Tuple2(tuple2.e1, tuple2.e2.transform()))
      .then((tuple2) => createBook(tuple2.e2, tuple2.e1))
      .then((book) => _bookService.update(book))
      .then((book) => ok(book, req))
      .catchError((e) => handleErrors(e, req));

  void listEvents(HttpRequest req, Params params) => Future.value(PathParam4(
          params, notEmptyString, requiredAuthorId, notEmptyString, requiredBookId, positiveInteger, positivePageLimit, positiveInteger, positivePageOffset))
      .then((params) => params.transform())
      .then((params) => _bookService.listEvents(params.e1, params.e2, PageRequest(params.e3, params.e3)))
      .then((authors) => ok(authors, req))
      .catchError((e) => handleErrors(e, req));

  Book createBook(Tuple2<String, String> params, NewBookForm form) => Book.update(params.e2, form.title, form.description, params.e1);

  Book formToBook(Tuple1<String> authorIdBox, NewBookForm form) => Book.create(form.title, form.description, authorIdBox.e1);
}
