import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:logging/logging.dart';

import 'package:quotesbe/domain/author/model/command.dart';
import 'package:quotesbe/domain/author/model/query.dart';
import 'package:quotesbe/domain/author/service.dart';
import 'package:quotesbe/domain/web/common/request.dart';
import 'package:quotesbe/domain/web/common/response.dart';
import 'package:quotesbe/web/error.dart';
import 'package:quotesbe/web/response.dart';

class AuthorController {
  final Logger _logger = Logger('AuthorController');

  final AuthorService _authorService;

  AuthorController(this._authorService);

  List<ValidationRule> newAuthorValidationRules = [
    ValidationRule("name", "Name cannot be empty", emptyString),
    ValidationRule("description", "Description cannot be empty", emptyString)
  ];

  List<ValidationRule> updateAuthorValidationRules = [
    ValidationRule("name", "Name cannot be empty", emptyString),
    ValidationRule("description", "Description cannot be empty", emptyString)
  ];

  Future<Response> search(Request request) async {
    var query = extractSearchQuery(request);

    return _authorService
        .findAuthors(query)
        .then((page) => jsonResponseOk(page))
        .onError<Exception>((error, stackTrace) => handleError(error));
  }

  Future<Response> store(Request request) async {
    var json = jsonDecode(await request.readAsString()) as Map;

    var violations = validate(newAuthorValidationRules, json);
    if (violations.isNotEmpty) {
      _logger.warning("[save author] validation error: $violations");
      return responseBadRequest(violations);
    }

    var command = NewAuthorCommand(json["name"], json["description"]);

    return _authorService
        .save(command)
        .then((author) => jsonResponseOk(author))
        .onError<Exception>((error, stackTrace) => handleError(error));
  }

  Future<Response> update(Request request, String authorId) async {
    var json = jsonDecode(await request.readAsString()) as Map;

    var violations = validate(updateAuthorValidationRules, json);
    if (violations.isNotEmpty) {
      _logger.warning("[update author] validation error: $violations");
      return responseBadRequest(violations);
    }

    var command =
        UpdateAuthorCommand(authorId, json["name"], json["description"]);

    return _authorService
        .update(command)
        .then((author) => jsonResponseOk(author))
        .onError<Exception>((error, stackTrace) => handleError(error));
  }

  Future<Response> find(Request request, String authorId) => _authorService
      .find(FindAuthorQuery(authorId))
      .then((author) => jsonResponseOk(author))
      .onError<Exception>((error, stackTrace) => handleError(error));

  Future<Response> delete(Request request, String authorId) => _authorService
      .delete(DeleteAuthorQuery(authorId))
      .then((_) => emptyResponseOk())
      .onError<Exception>((error, stackTrace) => handleError(error));

  Future<Response> listEvents(Request request, String authorId) async {
    var query = ListEventsByAuthorQuery(authorId, extractPageRequest(request));
    return await _authorService
        .listEvents(query)
        .then((page) => jsonResponseOk(page))
        .onError<Exception>((error, stackTrace) => handleError(error));
  }
}
