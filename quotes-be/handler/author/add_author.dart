import 'dart:io';

import './../common.dart';
import '../../domain/author/service.dart';
import '../../domain/author/form.dart';
import '../../domain/author/model.dart';


class AddAuthorHandler extends Handler {
  static final _URL = r"/authors";

  AuthorService _authorService;

  AddAuthorHandler(this._authorService) : super(_URL, "POST");

  void execute(HttpRequest request) {
    parseForm(request, new AuthorFormParser())
        .then((form) => formToAuthor(form))
        .then((author) async => await _authorService.save(author).then(
            (author) => created(author, request),
            onError: (e) => handleErrors(e, request)))
        .catchError((e) => handleErrors(e, request));
  }

  Author formToAuthor(AuthorForm form) {
    return new Author(null, form.name);
  }
}
