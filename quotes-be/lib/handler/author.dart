import 'dart:io';

import 'package:logging/logging.dart';


import '../domain/author/model.dart';
import '../domain/author/service.dart';
import 'common/form.dart';
import 'author/form.dart';
import 'author/params.dart';
import 'form.dart';
import 'response.dart';
import 'error_handler.dart';


class AuthorHandler {
  static final Logger logger = Logger('AuthorHandler');

  AuthorService _authorService;

  AuthorHandler(this._authorService) : super();

  void find(HttpRequest req, PathParams pathParams, UrlParams urlParams) =>
      Future.value(AuthorIdParams(pathParams.getString("authorId")))
          .then((params) => params.validate())
          .then((params) => _authorService.find(params.authorId))
          .then((a) => ok(a, req))
          .catchError((e) => handleErrors(e, req));

  void persist(HttpRequest request, PathParams pathParams, UrlParams urlParams) =>
    parseForm(request, AuthorFormParser(false, false))
           .then(createAuthor)
           .then(_authorService.save)
           .then((author) => created(author, request))
           .catchError((e) => handleErrors(e, request));

   Author createAuthor(AuthorForm form) => Author.create(form.name, form.description);
}
