import 'dart:io';

import './../common.dart';
import '../../domain/book/service.dart';
import '../../domain/book/form.dart';
import '../../domain/common/form.dart';
import '../../domain/book/model.dart';

class UpdateBookHandler extends Handler {
  static final _URL = r"/authors/{authorId}/books/{bookId}";

  BookService _bookService;

  UpdateBookHandler(this._bookService) : super(_URL, "PUT");

  void execute(
      HttpRequest request, PathParseResult pathParams, UrlParams urlParams) {
    var authorId = pathParams.getString("authorId");
    var bookId = pathParams.getString("bookId");
    var errors = ParseElem.errors([authorId, bookId]);
    if (errors.length > 0) {
      badRequest(errors, request);
      return;
    }

    parseForm(request, BookFormParser())
        .then((form) => Book(bookId.value, form.title, authorId.value))
        .then((book) => _bookService.update(book))
        .then((book) => ok(book, request))
        .catchError((e) => handleErrors(e, request));
  }
}
