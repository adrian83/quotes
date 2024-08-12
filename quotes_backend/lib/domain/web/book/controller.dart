import 'dart:convert';

import 'package:shelf/shelf.dart';

import 'package:quotes_backend/domain/book/service.dart';
import 'package:quotes_backend/domain/book/model/command.dart';
import 'package:quotes_backend/domain/book/model/query.dart';
import 'package:quotes_backend/domain/web/common/request.dart';
import 'package:quotes_backend/domain/web/common/response.dart';
import 'package:quotes_backend/web/error.dart';
import 'package:quotes_backend/web/response.dart';

class BookController {
  final BookService _bookService;

  BookController(this._bookService);

  List<ValidationRule> newBookValidationRules = [
    ValidationRule("title", "Title cannot be empty", emptyString),
    ValidationRule("description", "Description cannot be empty", emptyString),
  ];

  List<ValidationRule> updateBookValidationRules = [
    ValidationRule("title", "Title cannot be empty", emptyString),
    ValidationRule("description", "Description cannot be empty", emptyString),
  ];

  Future<Response> search(Request request) async => Future.value(request)
      .then((req) => extractSearchQuery(req))
      .then((query) => _bookService.findBooks(query))
      .then((page) => jsonResponseOk(page))
      .onError<Exception>((error, stackTrace) => handleError(error));

  Future<Response> searchAuthorBooks(Request request, String authorId) async => Future.value(request)
      .then((req) => ListBooksByAuthorQuery(authorId, extractPageRequest(req)))
      .then((query) => _bookService.findAuthorBooks(query))
      .then((page) => jsonResponseOk(page))
      .onError<Exception>((error, stackTrace) => handleError(error));

  Future<Response> store(Request request, String authorId) async => Future.value(request)
      .then((req) => req.readAsString())
      .then((body) => jsonDecode(body) as Map)
      .then((json) => validate(newBookValidationRules, json))
      .then((json) => NewBookCommand(authorId, json["title"], json["description"]))
      .then((command) => _bookService.save(command))
      .then((author) => jsonResponseOk(author))
      .onError<Exception>((error, stackTrace) => handleError(error));

  Future<Response> update(Request request, String authorId, String bookId) async => Future.value(request)
      .then((req) => req.readAsString())
      .then((body) => jsonDecode(body) as Map)
      .then((json) => validate(updateBookValidationRules, json))
      .then((json) => UpdateBookCommand(authorId, bookId, json["title"], json["description"]))
      .then((command) => _bookService.update(command))
      .then((book) => jsonResponseOk(book))
      .onError<Exception>((error, stackTrace) => handleError(error));

  Future<Response> find(Request request, String authorId, String bookId) =>
      _bookService.find(FindBookQuery(authorId, bookId)).then((book) => jsonResponseOk(book)).onError<Exception>((error, stackTrace) => handleError(error));

  Future<Response> delete(Request request, String authorId, String bookId) =>
      _bookService.delete(DeleteBookCommand(authorId, bookId)).then((_) => emptyResponseOk()).onError<Exception>((error, stackTrace) => handleError(error));

  Future<Response> listEvents(Request request, String authorId, String bookId) async => Future.value(request)
      .then((req) => extractPageRequest(req))
      .then((page) => ListEventsByBookQuery(authorId, bookId, page))
      .then((query) => _bookService.listEvents(query))
      .then((page) => jsonResponseOk(page))
      .onError<Exception>((error, stackTrace) => handleError(error));
}
