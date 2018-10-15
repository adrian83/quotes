import 'dart:io';

import './../common.dart';
import '../../domain/author/service.dart';
import '../../domain/author/form.dart';
import '../../domain/author/model.dart';

import '../../domain/common/exception.dart';

class AddAuthorHandler extends Handler {
  static final _URL = r"/authors";

  AuthorService _authorService;

  AddAuthorHandler(this._authorService) : super(_URL, "POST");

  void execute(HttpRequest request) async {
 parseForm(request, new AuthorFormParser()).then((result){
  if(result.hasErrors()) throw InvalidDataException(result.errors);
  return formToAuthor(result.form);
}).then((author) async {
  return await _authorService.save(author).then(
      (author) => created(author, request),
      onError: (e) => handleErrors(e, request));
})
.catchError((e) => handleErrors(e, request));

/*
    var result = await parseForm(request, new AuthorFormParser());
    if (result.hasErrors()) {
      badRequest(result.errors, request);
      return;
    }

    var author = formToAuthor(result.form);
    return
    */
  }

  Author formToAuthor(AuthorForm form) {
    return new Author(null, form.name);
  }
}
