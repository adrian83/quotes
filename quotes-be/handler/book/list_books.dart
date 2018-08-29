import 'dart:io';

import './../common.dart';
import '../../domain/book/service.dart';

class ListBooksHandler extends Handler {
  static final _URL = r"/authors/{authorId}/books";

  BookService _bookService;

  ListBooksHandler(this._bookService) : super(_URL, "GET") {}

  void execute(HttpRequest request) {

    var pathParsed = parsePath(request.requestedUri.pathSegments);
    var idOrErr = pathParsed.getString("authorId");
    if (idOrErr.hasError()) {
      badRequest([idOrErr.error], request);
      return;
    }

    var books = _bookService.findByAuthor(idOrErr.value);
    ok(books, request);
  }
}
