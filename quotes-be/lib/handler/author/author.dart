import 'dart:io';

import 'package:logging/logging.dart';

import 'form.dart';
import 'params.dart';
import '../common/form.dart';
import '../common/params.dart';
import '../error_handler.dart';
import '../form.dart';
import '../response.dart';
import '../param.dart';
import '../../common/time.dart';
import '../../common/tuple.dart';
import '../../domain/author/model.dart';
import '../../domain/author/service.dart';
import '../../domain/common/model.dart';

var requiredAuthorId = ParamData("authorId", "authorId cannot be empty");


class AuthorHandler {
  static final Logger logger = Logger('AuthorHandler');

  AuthorService _authorService;

  AuthorHandler(this._authorService);

  void find(HttpRequest req, PathParams pathParams, UrlParams urlParams) => 
    Future.value(PathParam1(pathParams, notEmptyString, requiredAuthorId))
          .then((param) => param.transform())
          .then((box) => _authorService.find(box.e1))
          .then((a) => ok(a, req))
          .catchError((e) => handleErrors(e, req));
  
  void persist(
          HttpRequest request, PathParams pathParams, UrlParams urlParams) =>
      parseForm(request, AuthorFormParser(false, false))
          .then(formToAuthor)
          .then(_authorService.save)
          .then((author) => created(author, request))
          .catchError((e) => handleErrors(e, request));

  void delete(HttpRequest req, PathParams pathParams, UrlParams urlParams) =>
    Future.value(PathParam1(pathParams, notEmptyString, requiredAuthorId))
          .then((param) => param.transform())
          .then((params) => _authorService.delete(params.e1))
          .then((_) => ok(null, req))
          .catchError((e) => handleErrors(e, req));

  void search(HttpRequest req, PathParams pathParams, UrlParams urlParams) =>
      Future.value(SearchParams(
              urlParams.getOptionalString("searchPhrase"),
              urlParams.getIntOrElse("limit", 2),
              urlParams.getIntOrElse("offset", 0)))
          .then((params) => params.validate())
          .then((params) => _authorService.findAuthors(
              params.searchPhrase, PageRequest(params.limit, params.offset)))
          .then((authors) => ok(authors, req))
          .catchError((e) => handleErrors(e, req));

  void listEvents(
          HttpRequest req, PathParams pathParams, UrlParams urlParams) =>
      Future.value(ListByAuthorParams(
              pathParams.getString("authorId"),
              urlParams.getIntOrElse("limit", 2),
              urlParams.getIntOrElse("offset", 0)))
          .then((params) => params.validate())
          .then((params) => _authorService.listEvents(
              params.authorId, PageRequest(params.limit, params.offset)))
          .then((authors) => ok(authors, req))
          .catchError((e) => handleErrors(e, req));

  void update(HttpRequest req, PathParams pathParams, UrlParams urlParams) =>
      parseForm(req, AuthorFormParser(true, true))
          .then((form) =>
              Tuple2(form, PathParam1(pathParams, notEmptyString, requiredAuthorId)))
          .then((tuple2) => Tuple2(tuple2.e1, tuple2.e2.transform()))
          .then((tuple2) => createAuthor(tuple2.e2, tuple2.e1))
          .then((author) => _authorService.update(author))
          .then((author) => ok(author, req))
          .catchError((e) => handleErrors(e, req));

  Author createAuthor(Tuple1<String> authorIdBox, AuthorForm form) => Author(
      authorIdBox.e1, form.name, form.description, nowUtc(), form.createdUtc);

  Author formToAuthor(AuthorForm form) =>
      Author.create(form.name, form.description);
}
