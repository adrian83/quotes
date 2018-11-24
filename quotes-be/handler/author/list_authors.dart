import 'dart:io';

import '../common.dart';

import '../common/form.dart';

import '../../domain/author/service.dart';
import '../../domain/common/model.dart';

class ListAuthorsHandler extends Handler {
  static final _URL = r"/authors";

  AuthorService _authorService;

  ListAuthorsHandler(this._authorService) : super(_URL, "GET") {}

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

    _authorService
        .findAuthors(req)
        .then((authors) => ok(authors, request))
        .catchError((e) => handleErrors(e, request));
    
  }
}
