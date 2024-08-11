import 'dart:convert';

import 'package:shelf/shelf.dart';

import 'package:quotesbe/domain/author/model/command.dart';
import 'package:quotesbe/domain/author/model/query.dart';
import 'package:quotesbe/domain/author/service.dart';
import 'package:quotesbe/domain/web/common/request.dart';
import 'package:quotesbe/domain/web/common/response.dart';
import 'package:quotesbe/web/error.dart';
import 'package:quotesbe/web/response.dart';

class AuthorController {
  final AuthorService _authorService;

  AuthorController(this._authorService);

  List<ValidationRule> newAuthorValidationRules = [
    ValidationRule("name", "Name cannot be empty", emptyString),
    ValidationRule("description", "Description cannot be empty", emptyString),
  ];

  List<ValidationRule> updateAuthorValidationRules = [
    ValidationRule("name", "Name cannot be empty", emptyString),
    ValidationRule("description", "Description cannot be empty", emptyString),
  ];

  Future<Response> search(Request request) async => Future.value(request)
      .then((req) => extractSearchQuery(req))
      .then((query) => _authorService.findAuthors(query))
      .then((page) => jsonResponseOk(page))
      .onError<Exception>((error, stackTrace) => handleError(error));

  Future<Response> store(Request request) async => Future.value(request)
      .then((req) => req.readAsString())
      .then((body) => jsonDecode(body) as Map)
      .then((json) => validate(newAuthorValidationRules, json))
      .then((json) => NewAuthorCommand(json["name"], json["description"]))
      .then((command) => _authorService.save(command))
      .then((author) => jsonResponseOk(author))
      .onError<Exception>((error, stackTrace) => handleError(error));

  Future<Response> update(Request request, String authorId) async => Future.value(request)
      .then((req) => req.readAsString())
      .then((body) => jsonDecode(body) as Map)
      .then((json) => validate(updateAuthorValidationRules, json))
      .then((json) => UpdateAuthorCommand(authorId, json["name"], json["description"]))
      .then((command) => _authorService.update(command))
      .then((author) => jsonResponseOk(author))
      .onError<Exception>((error, stackTrace) => handleError(error));

  Future<Response> find(Request request, String authorId) => Future.value(FindAuthorQuery(authorId))
      .then((query) => _authorService.find(query))
      .then((author) => jsonResponseOk(author))
      .onError<Exception>((error, stackTrace) => handleError(error));

  Future<Response> delete(Request request, String authorId) => Future.value(DeleteAuthorQuery(authorId))
      .then((query) => _authorService.delete(query))
      .then((_) => emptyResponseOk())
      .onError<Exception>((error, stackTrace) => handleError(error));

  Future<Response> listEvents(Request request, String authorId) async => Future.value(request)
      .then((req) => extractPageRequest(req))
      .then((page) => ListEventsByAuthorQuery(authorId, page))
      .then((query) => _authorService.listEvents(query))
      .then((page) => jsonResponseOk(page))
      .onError<Exception>((error, stackTrace) => handleError(error));
}
