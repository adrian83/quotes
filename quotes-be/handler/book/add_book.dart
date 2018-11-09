import 'dart:io';

import 'form.dart';

import '../common.dart';
import '../common/form.dart';

import '../../domain/book/service.dart';
import '../../domain/book/model.dart';

class AddBookHandler extends Handler {
  static final _URL = r"/authors/{authorId}/books";

  BookService _bookService;

  AddBookHandler(this._bookService) : super(_URL, "POST");

  void execute(HttpRequest request, PathParams pathParams, UrlParams urlParams) {
    var pathParsed = parsePath(request.requestedUri.pathSegments);
    var authorId = pathParsed.getString("authorId");
    if (authorId.hasError()) {
      badRequest([authorId.error], request);
      return;
    }

    parseForm(request, BookFormParser())
        .then((form) => Book(null, form.title, authorId.value))
        .then((book) => _bookService.save(book))
        .then((book) => created(book, request))
        .catchError((e) => handleErrors(e, request));
  }
}
