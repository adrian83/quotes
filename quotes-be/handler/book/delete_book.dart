import 'dart:io';

import '../common.dart';
import '../common/form.dart';

import './../common.dart';
import '../../domain/book/service.dart';

class DeleteBookHandler extends Handler {
  static final _URL = r"/authors/{authorId}/books/{bookId}";

  BookService _bookService;

  DeleteBookHandler(this._bookService) : super(_URL, "DELETE");

  void execute(
      HttpRequest request, PathParams pathParams, UrlParams urlParams) {
    var pathParsed = parsePath(request.requestedUri.pathSegments);
    var authorId = pathParsed.getString("authorId");
    var bookId = pathParsed.getString("bookId");

    var errors = ParseElem.errors([authorId, bookId]);
    if (errors.length > 0) {
      badRequest(errors, request);
      return;
    }

    _bookService
        .delete(bookId.value)
        .then((_) => ok(null, request))
        .catchError((e) => handleErrors(e, request));
  }
}
