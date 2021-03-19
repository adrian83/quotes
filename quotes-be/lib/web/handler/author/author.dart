import 'dart:io';

import 'package:logging/logging.dart';

import 'form.dart';
import '../error.dart';
import '../../../infrastructure/web/form.dart';
import '../../../infrastructure/web/response.dart';
import '../../../infrastructure/web/param.dart';
import '../../../domain/author/service.dart';

var authorIdParam = "authorId";
var searchPhraseParam = "searchPhrase";
var limitParam = "limit";
var offsetParam = "offset";

class AuthorHandler {
  static final Logger _logger = Logger('AuthorHandler');

  AuthorService _authorService;

  AuthorHandler(this._authorService);

  void find(HttpRequest req, Params params) => Future.value(params)
      .then((_) => _logger.info("find author request with params: $params"))
      .then((_) => FindAuthorParams(params))
      .then((params) => _authorService.find(params.getAuthorId()))
      .then((a) => ok(a, req))
      .catchError((e) => handleErrors(e, req));

  void persist(HttpRequest req, Params params) => Future.value(params)
      .then((_) => _logger.info("persist author request with params: $params"))
      .then((_) => readForm(req))
      .then((form) => PersistAuthorParams(form, params))
      .then((params) => _authorService.save(params.toAuthor()))
      .then((author) => created(author, req))
      .catchError((e) => handleErrors(e, req));

  void delete(HttpRequest req, Params params) => Future.value(params)
      .then((_) => _logger.info("delete author request with params: $params"))
      .then((_) => DeleteAuthorParams(params))
      .then((params) => _authorService.delete(params.getAuthorId()))
      .then((_) => ok(null, req))
      .catchError((e) => handleErrors(e, req));

  void search(HttpRequest req, Params params) => Future.value(params)
      .then((_) => _logger.info("search for authors request with params: $params"))
      .then((_) => SearchParams(params))
      .then((params) => _authorService.findAuthors(params.toSearchEntityRequest()))
      .then((authors) => ok(authors, req))
      .catchError((e) => handleErrors(e, req));

  void listEvents(HttpRequest req, Params params) => Future.value(params)
      .then((_) => _logger.info("list author events request with params: $params"))
      .then((_) => ListEventsByAuthorParams(params))
      .then((params) => _authorService.listEvents(params.toListEventsByAuthorRequest()))
      .then((authors) => ok(authors, req))
      .catchError((e) => handleErrors(e, req));

  void update(HttpRequest req, Params params) => Future.value(params)
      .then((_) => _logger.info("update author request with params: $params"))
      .then((_) => readForm(req))
      .then((form) => UpdateAuthorParams(form, params))
      .then((params) => _authorService.update(params.toAuthor()))
      .then((author) => ok(author, req))
      .catchError((e) => handleErrors(e, req));
}
