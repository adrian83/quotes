import 'dart:io';

import './../common.dart';
import '../../domain/author/service.dart';
import '../../domain/common/form.dart';

class GetAuthorHandler extends Handler {
  static final _URL = r"/authors/{authorId}";

  AuthorService _authorService;

  GetAuthorHandler(this._authorService) : super(_URL, "GET");

  void execute(HttpRequest request, PathParseResult pathParams, UrlParams urlParams) {

    var idOrErr = pathParams.getString("authorId");
    if (idOrErr.hasError()) {
      badRequest([idOrErr.error], request);
      return;
    }

    _authorService
        .find(idOrErr.value)
        .then((a) => ok(a, request))
        .catchError((e) => handleErrors(e, request));
  }
}
