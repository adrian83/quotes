import 'dart:io';

import 'form.dart';

import '../common/form.dart';

import './../common.dart';
import '../../domain/author/service.dart';
import '../../domain/author/model.dart';

class AddAuthorHandler extends Handler {
  static final _URL = r"/authors";

  AuthorService _authorService;

  AddAuthorHandler(this._authorService) : super(_URL, "POST");

  void execute(
          HttpRequest request, PathParams pathParams, UrlParams urlParams) =>
      parseForm(request, AuthorFormParser(false))
          .then((form) => Author(null, form.name, form.description, nowUtc()))
          .then((author) => _authorService.save(author))
          .then((author) => created(author, request))
          .catchError((e) => handleErrors(e, request));
}
