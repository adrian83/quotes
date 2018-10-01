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
    var parsedForm = await parseForm(request, new AuthorFormParser());
    if (parsedForm.hasErrors()) {
      badRequest(parsedForm.errors, request);
      return;
    }

    var pathParsed = parsePath(request.requestedUri.pathSegments);
    var idOrErr = pathParsed.getString("authorId");
    if (idOrErr.hasError()) {
      badRequest([idOrErr.error], request);
      return;
    }

    var quote = formToAuthor(parsedForm.form, idOrErr.value);
    var saved = await _authorService.update(quote);
    ok(saved, request);
  }

  Author formToAuthor(AuthorForm form, String authorId) {
    return new Author(authorId, form.name);
  }
}
