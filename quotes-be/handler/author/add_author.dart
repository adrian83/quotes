import 'dart:io';

import './../common.dart';
import '../../domain/author/service.dart';
import '../../domain/author/form.dart';
import '../../domain/author/model.dart';
import '../../domain/common/form.dart';

class AddAuthorHandler extends Handler {
  static final _URL = r"/authors";

  AuthorService _authorService;

  AddAuthorHandler(this._authorService) : super(_URL, "POST");

  void execute(
      HttpRequest request, PathParseResult pathParams, UrlParams urlParams) {
    parseForm(request, AuthorFormParser())
        .then((form) => Author(null, form.name, form.description))
        .then((author) => _authorService.save(author))
        .then((author) => created(author, request))
        .catchError((e) => handleErrors(e, request));
  }
}
