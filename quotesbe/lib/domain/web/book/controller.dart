import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:logging/logging.dart';

import 'package:quotesbe/domain/book/service.dart';
import 'package:quotesbe/domain/book/model/command.dart';
import 'package:quotesbe/domain/book/model/query.dart';
import 'package:quotesbe/domain/web/common/request.dart';
import 'package:quotesbe/domain/web/common/response.dart';
import 'package:quotesbe/web/error.dart';
import 'package:quotesbe/web/response.dart';

class BookController {
  final Logger _logger = Logger('BookController');

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

  Future<Response> search(Request request) async {
    var query = extractSearchQuery(request);

    return _bookService.findBooks(query).then((page) => jsonResponseOk(page)).onError<Exception>((error, stackTrace) => handleError(error));
  }

  Future<Response> searchAuthorBooks(Request request, String authorId) async {
    var query = ListBooksByAuthorQuery(authorId, extractPageRequest(request));

    return _bookService.findAuthorBooks(query).then((page) => jsonResponseOk(page)).onError<Exception>((error, stackTrace) => handleError(error));
  }

  Future<Response> store(Request request, String authorId) async {
    var json = jsonDecode(await request.readAsString()) as Map;

    var violations = validate(newBookValidationRules, json);
    if (violations.isNotEmpty) {
      _logger.warning("[save book] validation error: $violations");
      return responseBadRequest(violations);
    }

    var command = NewBookCommand(authorId, json["title"], json["description"]);

    return _bookService.save(command).then((author) => jsonResponseOk(author)).onError<Exception>((error, stackTrace) => handleError(error));
  }

  Future<Response> update(
    Request request,
    String authorId,
    String bookId,
  ) async {
    var json = jsonDecode(await request.readAsString()) as Map;

    var violations = validate(updateBookValidationRules, json);
    if (violations.isNotEmpty) {
      _logger.warning("[update book] validation error: $violations");
      return responseBadRequest(violations);
    }

    var command = UpdateBookCommand(authorId, bookId, json["title"], json["description"]);

    return _bookService.update(command).then((book) => jsonResponseOk(book)).onError<Exception>((error, stackTrace) => handleError(error));
  }

  Future<Response> find(Request request, String authorId, String bookId) =>
      _bookService.find(FindBookQuery(authorId, bookId)).then((book) => jsonResponseOk(book)).onError<Exception>((error, stackTrace) => handleError(error));

  Future<Response> delete(Request request, String authorId, String bookId) =>
      _bookService.delete(DeleteBookCommand(authorId, bookId)).then((_) => emptyResponseOk()).onError<Exception>((error, stackTrace) => handleError(error));

  Future<Response> listEvents(
    Request request,
    String authorId,
    String bookId,
  ) async {
    var query = ListEventsByBookQuery(authorId, bookId, extractPageRequest(request));
    return await _bookService.listEvents(query).then((page) => jsonResponseOk(page)).onError<Exception>((error, stackTrace) => handleError(error));
  }
}
