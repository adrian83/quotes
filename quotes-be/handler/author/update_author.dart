import 'dart:io';

import 'form.dart';

import '../common.dart';
import '../common/form.dart';

import '../../domain/author/service.dart';
import '../../domain/author/model.dart';

class UpdateAuthorHandler extends Handler {
  static final _URL = r"/authors/{authorId}";

  AuthorService _authorService;

  UpdateAuthorHandler(this._authorService) : super(_URL, "PUT") {}

  void execute(
      HttpRequest request, PathParams pathParams, UrlParams urlParams) {
    var authorId = pathParams.getString("authorId");
    if (authorId.hasError()) {
      badRequest([authorId.error], request);
      return;
    }

    parseForm(request, AuthorFormParser())
        .then((form) => Author(authorId.value, form.name, form.description))
        .then((quote) => _authorService.update(quote))
        .then((author) => ok(author, request))
        .catchError((e) => handleErrors(e, request));
  }
}
