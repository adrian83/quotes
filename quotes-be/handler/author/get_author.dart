import 'dart:io';
import 'dart:convert';

import './../common.dart';
import '../../domain/author/service.dart';
import '../../domain/author/form.dart';
import '../../domain/common/form.dart';
import '../../domain/author/model.dart';

class GetAuthorHandler extends Handler {
  final _URL = r"/authors/{authorId}";

  AuthorService _authorService;

  GetAuthorHandler(this._authorService) : super(_URL, "GET");

  void execute(HttpRequest request) async {
    var pathParsed = parsePath(request.requestedUri.pathSegments);
    var idOrErr = pathParsed.getString("authorId");

    if (idOrErr.hasError()) {
      badRequest([idOrErr.error], request);
      return;
    }

    var quote = _authorService.find(idOrErr.value);
    if (quote == null) {
      notFound(request);
      return;
    }

    ok(quote, request);
  }
}
