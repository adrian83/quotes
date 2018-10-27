import 'dart:io';

import './../common.dart';
import '../../domain/book/service.dart';
import '../../domain/book/form.dart';
import '../../domain/book/model.dart';
import '../../domain/common/form.dart';

class AddBookHandler extends Handler {
  static final _URL = r"/authors/{authorId}/books";

  BookService _bookService;

  AddBookHandler(this._bookService) : super(_URL, "POST");

  void execute(HttpRequest request, PathParseResult pathParams, UrlParams urlParams) {
    var pathParsed = parsePath(request.requestedUri.pathSegments);
    var idOrErr = pathParsed.getString("authorId");
    if (idOrErr.hasError()) {
      badRequest([idOrErr.error], request);
      return;
    }

    parseForm(request, BookFormParser())
        .then((form) => Book(null, form.title, idOrErr.value))
        .then((book) => _bookService.save(book))
        .then((book) => created(book, request))
        .catchError((e) => handleErrors(e, request));
  }
}
