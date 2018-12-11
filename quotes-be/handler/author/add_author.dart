import 'dart:io';

import 'package:logging/logging.dart';

import './../common.dart';
import '../../domain/author/model.dart';
import '../../domain/author/service.dart';
import '../../tools/logging.dart';
import '../common/form.dart';
import 'form.dart';

class AddAuthorHandler extends Handler {
  static final Logger logger = Logger('AddAuthorHandler');

  static final _URL = r"/authors";

  AuthorService _authorService;

  AddAuthorHandler(this._authorService) : super(_URL, "POST");

  Author authorFromForm(AuthorForm form) =>
      Author(null, form.name, form.description, nowUtc(), nowUtc());

  void execute(
          HttpRequest request, PathParams pathParams, UrlParams urlParams) =>
      parseForm(request, AuthorFormParser(false, false))
          .then((form) => authorFromForm(form))
          .then((author) => log(logger, author, "Create author: $author"))
          .then((author) => _authorService.save(author))
          .then((author) => created(author, request))
          .catchError((e) => handleErrors(e, request));
}
