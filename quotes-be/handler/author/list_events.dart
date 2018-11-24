import 'dart:io';
import 'dart:async';

import '../common.dart';

import '../common/exception.dart';
import '../common/form.dart';

import '../../domain/author/service.dart';
import '../../domain/common/model.dart';

class AuthorEventsHandler extends Handler {
  static final _URL = r"/authors/{authorId}/events";

  AuthorService _authorService;

  AuthorEventsHandler(this._authorService) : super(_URL, "GET") {}

  void execute(
      HttpRequest request, PathParams pathParams, UrlParams urlParams) {
    var limit = urlParams.getIntOrElse("limit", 2);
    var offset = urlParams.getIntOrElse("offset", 0);

    var errors = ParseElem.errors([limit, offset]);
    if (errors.length > 0) {
      badRequest(errors, request);
      return;
    }

    var req = PageRequest(limit.value, offset.value);

    Future.value(pathParams.getString("authorId"))
        .then((authorId) => authorId.hasError()
            ? throw InvalidDataException([authorId.error])
            : authorId.value)
        .then((authorId) => _authorService.listEvents(authorId, req))
        .then((authors) => ok(authors, request))
        .catchError((e) => handleErrors(e, request));
  }
}
