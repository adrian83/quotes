import 'dart:io';
import 'dart:async';

import '../common/exception.dart';
import '../common/form.dart';

import './../common.dart';
import '../../domain/author/service.dart';

class GetAuthorHandler extends Handler {
  static final _URL = r"/authors/{authorId}";

  AuthorService _authorService;

  GetAuthorHandler(this._authorService) : super(_URL, "GET");

  void execute(
          HttpRequest request, PathParams pathParams, UrlParams urlParams) =>
      Future.value(pathParams.getString("authorId"))
          .then((authorId) => authorId.hasError()
              ? throw InvalidDataException([authorId.error])
              : authorId.value)
          .then((authorId) => _authorService.find(authorId))
          .then((a) => ok(a, request))
          .catchError((e) => handleErrors(e, request));
}
