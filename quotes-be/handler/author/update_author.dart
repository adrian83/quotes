import 'dart:io';

import './../common.dart';
import '../../domain/author/service.dart';
import '../../domain/author/form.dart';
import '../../domain/author/model.dart';
import '../../domain/common/form.dart';

class UpdateAuthorHandler extends Handler {
  static final _URL = r"/authors/{authorId}";

  AuthorService _authorService;

  UpdateAuthorHandler(this._authorService) : super(_URL, "PUT") {}

  void execute(HttpRequest request, PathParseResult pathParams, UrlParams urlParams) {

    var idOrErr = pathParams.getString("authorId");
    if (idOrErr.hasError()) {
      badRequest([idOrErr.error], request);
      return;
    }

    parseForm(request, new AuthorFormParser())
        .then((form) => Author(idOrErr.value, form.name))
        .then((quote) => _authorService.update(quote))
        .then((author) => ok(author, request))
        .catchError((e) => handleErrors(e, request));
  }
}
