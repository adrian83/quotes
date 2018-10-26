import 'dart:io';

import './../common.dart';
import '../../domain/author/service.dart';
import '../../domain/author/form.dart';
import '../../domain/author/model.dart';

class UpdateAuthorHandler extends Handler {
  static final _URL = r"/authors/{authorId}";

  AuthorService _authorService;

  UpdateAuthorHandler(this._authorService) : super(_URL, "PUT") {}

  void execute(HttpRequest request) async {
    var pathParsed = parsePath(request.requestedUri.pathSegments);
    var idOrErr = pathParsed.getString("authorId");
    if (idOrErr.hasError()) {
      badRequest([idOrErr.error], request);
      return;
    }

    parseForm(request, new AuthorFormParser())
        .then((form) => formToAuthor(form, idOrErr.value))
        .then((quote) async => await _authorService
            .update(quote)
            .then((author) => ok(author, request))
            .catchError((e) => handleErrors(e, request)))
        .catchError((e) => handleErrors(e, request));
  }

  Author formToAuthor(AuthorForm form, String authorId) {
    return new Author(authorId, form.name);
  }
}
