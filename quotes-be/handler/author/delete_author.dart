import 'dart:io';
import 'dart:async';

import '../common/exception.dart';
import '../common/form.dart';

import './../common.dart';
import '../../domain/author/service.dart';


class DeleteAuthorHandler extends Handler {
  static final _URL = r"/authors/{authorId}";

  AuthorService _authorService;

  DeleteAuthorHandler(this._authorService) : super(_URL, "DELETE");

  void execute(
          HttpRequest request, PathParams pathParams, UrlParams urlParams) =>
      Future.value(pathParams.getString("authorId"))
          .then((authorId) => authorId.hasError()
              ? throw InvalidDataException([authorId.error])
              : authorId.value)
          .then((authorId) => _authorService.delete(authorId))
          .then((_) => ok(null, request))
          .catchError((e) => handleErrors(e, request));
}
