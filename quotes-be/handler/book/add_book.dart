import 'dart:io';

import './../common.dart';
import '../../domain/book/service.dart';
import '../../domain/book/form.dart';
import '../../domain/book/model.dart';

class AddBookHandler extends Handler {
  static final _URL = r"/authors/{authorId}/books";

  BookService _bookService;

  AddBookHandler(this._bookService) : super(_URL, "POST");

  void execute(HttpRequest request) async {
    var pathParsed = parsePath(request.requestedUri.pathSegments);
    var idOrErr = pathParsed.getString("authorId");
    if (idOrErr.hasError()) {
      badRequest([idOrErr.error], request);
      return;
    }

    parseForm(request, new BookFormParser())
        .then((form) => Book(null, form.title, idOrErr.value))
        .then((book) async => await _bookService
            .save(book)
            .then((b) => created(b, request))
            .catchError((e) => handleErrors(e, request)))
        .catchError((e) => handleErrors(e, request));
  }
}
