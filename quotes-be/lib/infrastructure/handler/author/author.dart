import 'dart:io';

import 'package:logging/logging.dart';

import 'form.dart';
import '../error.dart';
import '../../web/form.dart';
import '../../web/path.dart';
import '../../web/response.dart';
import '../../web/param.dart';
import '../../../common/tuple.dart';
import '../../../domain/author/model.dart';
import '../../../domain/author/service.dart';
import '../../../domain/common/model.dart';

// var requiredAuthorId = ParamData("authorId", "authorId cannot be empty");
// var optionalSearchPhrase = ParamData("searchPhrase", "");
// var positivePageLimit = ParamData("limit", "limit should be a positive integer");
// var positivePageOffset = ParamData("offset", "offset should be a positive integer");

var authorIdParam = "authorId";
var searchPhraseParam = "searchPhrase";
var limitParam = "limit";
var offsetParam = "offset";

class AuthorHandler {
  static final Logger logger = Logger('AuthorHandler');

  AuthorService _authorService;

  AuthorHandler(this._authorService);

  void find(HttpRequest req, Params params) => Future.value(FindAuthorParams(params))
      .then((params) => _authorService.find(params.getAuthorId()))
      .then((a) => ok(a, req))
      .catchError((e) => handleErrors(e, req));

  void persist(HttpRequest req, Params params) => readForm(req)
      .then((form) => PersistAuthorParams(form, params))
      .then((params) => _authorService.save(params.toAuthor()))
      .then((author) => created(author, req))
      .catchError((e) => handleErrors(e, req));

  void delete(HttpRequest req, Params params) => Future.value(DeleteAuthorParams(params))
      .then((params) => _authorService.delete(params.getAuthorId()))
      .then((_) => ok(null, req))
      .catchError((e) => handleErrors(e, req));

  void search(HttpRequest req, Params params) => readForm(req)
      .then((form) => SearchParams(form, params))
      .then((params) => _authorService.findAuthors(params.toSearchEntityRequest()))
      .then((authors) => ok(authors, req))
      .catchError((e) => handleErrors(e, req));

  void listEvents(HttpRequest req, Params params) => Future.value(ListEventsByAuthorParams(params))
      .then((params) => _authorService.listEvents(params.toListEventsByAuthorRequest()))
      .then((authors) => ok(authors, req))
      .catchError((e) => handleErrors(e, req));

  void update(HttpRequest req, Params params) => readForm(req)
      .then((form) => UpdateAuthorParams(form, params))
      .then((params) => _authorService.update(params.toAuthor()))
      .then((author) => ok(author, req))
      .catchError((e) => handleErrors(e, req));
}
