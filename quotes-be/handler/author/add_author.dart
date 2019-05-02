import 'dart:io';

import 'package:logging/logging.dart';

import './../common.dart';
import '../../domain/author/model.dart';
import '../../domain/author/service.dart';
import '../common/form.dart';
import 'form.dart';

class AddAuthorHandler extends Handler {
  static final Logger logger = Logger('AddAuthorHandler');

  AuthorService _authorService;

  AddAuthorHandler(this._authorService) : super(); 

  void execute(HttpRequest req, PathParams pathParams, UrlParams urlParams) =>
      parseForm(req, AuthorFormParser(false, false))
          .then((form) => createAuthor(form))
          .then((author) => _authorService.save(author))
          .then((author) => created(author, req))
          .catchError((e) => handleErrors(e, req));

  Author createAuthor(AuthorForm form) =>
      Author(null, form.name, form.description, nowUtc(), nowUtc());
}
