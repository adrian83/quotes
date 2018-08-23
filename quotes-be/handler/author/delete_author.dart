import 'dart:io';

import './../common.dart';
import '../../domain/author/service.dart';
import '../../domain/common/form.dart';

class DeleteAuthorHandler extends Handler {
  final _URL = r"/authors/{authorId}";

  AuthorService _authorService;

  DeleteAuthorHandler(this._authorService) : super(_URL, "DELETE");

  void execute(HttpRequest request) async {
    var pathParsed = parsePath(request.requestedUri.pathSegments);
    var idOrErr = pathParsed.getString("authorId");
    if (idOrErr.hasError()) {
      badRequest([idOrErr.error], request);
      return;
    }

    _authorService.delete(idOrErr.value);
    ok(null, request);
  }
}
