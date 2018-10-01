import 'dart:io';

import './../common.dart';
import '../../domain/author/service.dart';

class GetAuthorHandler extends Handler {
  static final _URL = r"/authors/{authorId}";

  AuthorService _authorService;

  GetAuthorHandler(this._authorService) : super(_URL, "GET");

  void execute(HttpRequest request) async {
    var pathParsed = parsePath(request.requestedUri.pathSegments);
    var idOrErr = pathParsed.getString("authorId");

    if (idOrErr.hasError()) {
      badRequest([idOrErr.error], request);
      return;
    }

    var quote = await _authorService.find(idOrErr.value);
    if (quote == null) {
      notFound(request);
      return;
    }

    ok(quote, request);
  }
}
