import 'dart:io';

import 'package:logging/logging.dart';

import 'form.dart';
import 'params.dart';
import '../author/params.dart';
import '../common/form.dart';
import '../common/params.dart';
import '../error_handler.dart';
import '../form.dart';
import '../response.dart';
import '../../common/time.dart';
import '../../common/tuple.dart';
import '../../domain/book/model.dart';
import '../../domain/book/service.dart';
import '../../domain/common/model.dart';



class BookHandler {
  static final Logger logger = Logger('BookHandler');

  BookService _bookService;

  BookHandler(this._bookService);


  void persist(HttpRequest req, PathParams pathParams, UrlParams urlParams) =>
      parseForm(req, BookFormParser(false, false))
          .then((form) =>
              Tuple2(form, AuthorIdParams(pathParams.getString("authorId"))))
          .then((tuple2) => Tuple2(tuple2.e1, tuple2.e2.validate()))
          .then((tuple2) => formToAuthor(tuple2.e2, tuple2.e1))
          .then((book) => _bookService.save(book))
          .then((book) => created(book, req))
          .catchError((e) => handleErrors(e, req));

 void delete(HttpRequest req, PathParams pathParams, UrlParams urlParams) =>
      Future.value(BookIdParams(
              pathParams.getString("authorId"), pathParams.getString("bookId")))
          .then((params) => params.validate())
          .then((params) => _bookService.delete(params.bookId))
          .then((_) => ok(null, req))
          .catchError((e) => handleErrors(e, req));

  void search(HttpRequest req, PathParams pathParams, UrlParams urlParams) =>
      Future.value(SearchParams(
              urlParams.getOptionalString("searchPhrase"),
              urlParams.getIntOrElse("limit", 2),
              urlParams.getIntOrElse("offset", 0)))
          .then((params) => params.validate())
          .then((params) => _bookService.findBooks(
              params.searchPhrase, PageRequest(params.limit, params.offset)))
          .then((books) => ok(books, req))
          .catchError((e) => handleErrors(e, req));

  void find(HttpRequest req, PathParams pathParams, UrlParams urlParams) =>
      Future.value(BookIdParams(
              pathParams.getString("authorId"), pathParams.getString("bookId")))
          .then((params) => params.validate())
          .then((params) => _bookService.find(params.bookId))
          .then((book) => ok(book, req))
          .catchError((e) => handleErrors(e, req));

  void listByAuthor(HttpRequest req, PathParams pathParams, UrlParams urlParams) =>
      Future.value(ListByAuthorParams(
              pathParams.getString("authorId"),
              urlParams.getIntOrElse("limit", 2),
              urlParams.getIntOrElse("offset", 0)))
          .then((params) => params.validate())
          .then((params) => _bookService.findAuthorBooks(
              params.authorId, PageRequest(params.limit, params.offset)))
          .then((books) => ok(books, req))
          .catchError((e) => handleErrors(e, req));

  void update(HttpRequest req, PathParams pathParams, UrlParams urlParams) =>
      parseForm(req, BookFormParser(true, true))
          .then((form) => Tuple2(
              form,
              BookIdParams(pathParams.getString("authorId"),
                  pathParams.getString("bookId"))))
          .then((tuple2) => Tuple2(tuple2.e1, tuple2.e2.validate()))
          .then((tuple2) => createBook(tuple2.e2, tuple2.e1))
          .then((book) => _bookService.update(book))
          .then((book) => ok(book, req))
          .catchError((e) => handleErrors(e, req));

  void listEvents(HttpRequest req, PathParams pathParams, UrlParams urlParams) =>
      Future.value(ListByBookParams(
              pathParams.getString("authorId"),
              pathParams.getString("bookId"),
              urlParams.getIntOrElse("limit", 2),
              urlParams.getIntOrElse("offset", 0)))
          .then((params) => params.validate())
          .then((params) => _bookService.listEvents(params.authorId,
              params.bookId, PageRequest(params.limit, params.offset)))
          .then((authors) => ok(authors, req))
          .catchError((e) => handleErrors(e, req));

  Book createBook(BookIdValidParams params, BookForm form) => Book(
      params.bookId,
      form.title,
      form.description,
      params.authorId,
      nowUtc(),
      form.createdUtc);

  Book formToAuthor(AuthorIdValidParams params, BookForm form) => Book(
      null, form.title, form.description, params.authorId, nowUtc(), nowUtc());

}