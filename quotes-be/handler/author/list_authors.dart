import 'dart:io';

import './../common.dart';

import '../../domain/author/service.dart';
import '../../domain/common/form.dart';
import '../../domain/common/model.dart';

class ListAuthorsHandler extends Handler {
  static final _URL = r"/authors";

  AuthorService _authorService;

  ListAuthorsHandler(this._authorService) : super(_URL, "GET") {}

  void execute(
      HttpRequest request, PathParseResult pathParams, UrlParams urlParams) {
    print("$pathParams $urlParams");

    var limit = urlParams.getIntOrElse("limit", 2);
    if (limit.hasError()) {
      badRequest([limit.error], request);
      return;
    }

    var offset = urlParams.getIntOrElse("offset", 0);
    if (offset.hasError()) {
      badRequest([offset.error], request);
      return;
    }

    var req = PageRequest(limit.value, offset.value);

    _authorService
        .findAuthors(req)
        .then((authors) => ok(authors, request))
        .catchError((e) => handleErrors(e, request));
    ;
  }
}
