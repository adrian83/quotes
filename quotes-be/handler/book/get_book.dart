import 'dart:io';

import '../common.dart';
import '../common/form.dart';

import '../../domain/book/service.dart';

class GetBookHandler extends Handler {
  static final _URL = r"/authors/{authorId}/books/{bookId}";

  BookService _bookService;

  GetBookHandler(this._bookService) : super(_URL, "GET");

  void execute(
      HttpRequest request, PathParams pathParams, UrlParams urlParams) {
    var authorIdOrErr = pathParams.getString("authorId");
    var bookIdOrErr = pathParams.getString("bookId");

    var errors = ParseElem.errors([authorIdOrErr, bookIdOrErr]);
    if (errors.length > 0) {
      badRequest(errors, request);
      return;
    }

    _bookService
        .find(bookIdOrErr.value)
        .then((book) => ok(book, request))
        .catchError((e) => handleErrors(e, request));
  }
}
