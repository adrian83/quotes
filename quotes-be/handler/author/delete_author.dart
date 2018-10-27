import 'dart:io';

import './../common.dart';
import '../../domain/author/service.dart';
import '../../domain/common/form.dart';

class DeleteAuthorHandler extends Handler {
  static final _URL = r"/authors/{authorId}";

  AuthorService _authorService;

  DeleteAuthorHandler(this._authorService) : super(_URL, "DELETE");

  void execute(HttpRequest request, PathParseResult pathParams, UrlParams urlParams) {

    var idOrErr = pathParams.getString("authorId");
    if (idOrErr.hasError()) {
      badRequest([idOrErr.error], request);
      return;
    }

    _authorService
        .delete(idOrErr.value)
        .then((_) => ok(null, request))
        .catchError((e) => handleErrors(e, request));
    ;
  }
}
