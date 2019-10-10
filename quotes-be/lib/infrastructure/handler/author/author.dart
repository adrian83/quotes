import 'dart:io';

import 'package:logging/logging.dart';

import 'form.dart';
import '../error.dart';
import '../../web/form.dart';
import '../../web/response.dart';
import '../../web/param.dart';
import '../../../common/tuple.dart';
import '../../../domain/author/model.dart';
import '../../../domain/author/service.dart';
import '../../../domain/common/model.dart';

var requiredAuthorId = ParamData("authorId", "authorId cannot be empty");
var optionalSearchPhrase = ParamData("searchPhrase", "");
var positivePageLimit = ParamData("limit", "limit should be a positive integer");
var positivePageOffset = ParamData("offset", "offset should be a positive integer");

class AuthorHandler {
  static final Logger logger = Logger('AuthorHandler');

  AuthorService _authorService;

  AuthorHandler(this._authorService);

  void find(HttpRequest req, Params params) => Future.value(PathParam1(params, notEmptyString, requiredAuthorId))
      .then((param) => param.transform())
      .then((box) => _authorService.find(box.e1))
      .then((a) => ok(a, req))
      .catchError((e) => handleErrors(e, req));

  void persist(HttpRequest req, Params params) => parseForm(req, NewAuthorFormParser())
      .then(formToAuthor)
      .then(_authorService.save)
      .then((author) => created(author, req))
      .catchError((e) => handleErrors(e, req));

  void delete(HttpRequest req, Params params) => Future.value(PathParam1(params, notEmptyString, requiredAuthorId))
      .then((param) => param.transform())
      .then((params) => _authorService.delete(params.e1))
      .then((_) => ok(null, req))
      .catchError((e) => handleErrors(e, req));

  void search(HttpRequest req, Params params) =>
      Future.value(PathParam3(params, optionalString, optionalSearchPhrase, positiveInteger, positivePageLimit, positiveInteger, positivePageOffset))
          .then((params) => params.transform())
          .then((params) => _authorService.findAuthors(params.e1, PageRequest(params.e2, params.e3)))
          .then((authors) => ok(authors, req))
          .catchError((e) => handleErrors(e, req));

  void listEvents(HttpRequest req, Params params) =>
      Future.value(PathParam3(params, notEmptyString, requiredAuthorId, positiveInteger, positivePageLimit, positiveInteger, positivePageOffset))
          .then((params) => params.transform())
          .then((params) => _authorService.listEvents(params.e1, PageRequest(params.e2, params.e3)))
          .then((authors) => ok(authors, req))
          .catchError((e) => handleErrors(e, req));

  void update(HttpRequest req, Params params) => parseForm(req, NewAuthorFormParser())
      .then((form) => Tuple2(form, PathParam1(params, notEmptyString, requiredAuthorId)))
      .then((tuple2) => Tuple2(tuple2.e1, tuple2.e2.transform()))
      .then((tuple2) => createAuthor(tuple2.e2, tuple2.e1))
      .then((author) => _authorService.update(author))
      .then((author) => ok(author, req))
      .catchError((e) => handleErrors(e, req));

  Author createAuthor(Tuple1<String> authorIdBox, NewAuthorForm form) => Author.update(authorIdBox.e1, form.name, form.description);

  Author formToAuthor(NewAuthorForm form) => Author.create(form.name, form.description);
}
