import 'dart:io';

import './../common.dart';
import '../../domain/book/service.dart';
import '../../domain/common/form.dart';
import '../../domain/common/model.dart';
import '../../domain/common/form.dart';

class ListBooksHandler extends Handler {
  static final _URL = r"/authors/{authorId}/books";

  BookService _bookService;

  ListBooksHandler(this._bookService) : super(_URL, "GET");

  void execute(HttpRequest request, PathParseResult pathParams, UrlParams urlParams) {
    var pathParsed = parsePath(request.requestedUri.pathSegments);
    var idOrErr = pathParsed.getString("authorId");
    if (idOrErr.hasError()) {
      badRequest([idOrErr.error], request);
      return;
    }

    var params = new UrlParams(request.requestedUri.queryParameters);

    var limit = params.getIntOrElse("limit", 2);
    if (limit.hasError()) {
      badRequest([limit.error], request);
      return;
    }

    var offset = params.getIntOrElse("offset", 0);
    if (offset.hasError()) {
      badRequest([offset.error], request);
      return;
    }

    var req = new PageRequest(limit.value, offset.value);

     _bookService
        .findBooks(idOrErr.value, req)
        .then((books) => ok(books, request))
        .catchError((e) => handleErrors(e, request));
  }
}
