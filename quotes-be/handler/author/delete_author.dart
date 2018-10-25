import 'dart:io';

import './../common.dart';
import '../../domain/author/service.dart';

class DeleteAuthorHandler extends Handler {
  static final _URL = r"/authors/{authorId}";

  AuthorService _authorService;

  DeleteAuthorHandler(this._authorService) : super(_URL, "DELETE");

  void execute(HttpRequest request) async {
    var pathParsed = parsePath(request.requestedUri.pathSegments);
    var idOrErr = pathParsed.getString("authorId");
    if (idOrErr.hasError()) {
      badRequest([idOrErr.error], request);
      return;
    }

    await _authorService
        .delete(idOrErr.value)
        .then((_) => ok(null, request))
        .catchError((e) => handleErrors(e, request));
    ;
  }
}
