import 'dart:io';

import './../common.dart';
import '../../domain/author/service.dart';
import '../../domain/author/form.dart';
import '../../domain/author/model.dart';

class AddAuthorHandler extends Handler {
  static final _URL = r"/authors";

  AuthorService _authorService;

  AddAuthorHandler(this._authorService) : super(_URL, "POST");

  void execute(HttpRequest request) async {
    var result = await parseForm(request, new AuthorFormParser());
    if (result.hasErrors()) {
      badRequest(result.errors, request);
      return;
    }

    var author = formToAuthor(result.form);
    var saved = _authorService.save(author);
    created(saved, request);
  }

  Author formToAuthor(AuthorForm form) {
    return new Author(null, form.name);
  }
}
