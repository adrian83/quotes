import 'dart:io';

import './../common.dart';
import '../../domain/book/service.dart';
import '../../domain/common/form.dart';

class GetBookHandler extends Handler {
  static final _URL = r"/authors/{authorId}/books/{bookId}";

  BookService _bookService;

  GetBookHandler(this._bookService) : super(_URL, "GET");

  void execute(HttpRequest request) async {
    var pathParsed = parsePath(request.requestedUri.pathSegments);
    var authorIdOrErr = pathParsed.getString("authorId");
    var bookIdOrErr = pathParsed.getString("bookId");

    var errors = ParseElem.errors([authorIdOrErr, bookIdOrErr]);
    if (errors.length > 0) {
      badRequest(errors, request);
      return;
    }

    var quote = _bookService.find(authorIdOrErr.value, bookIdOrErr.value);
    if (quote == null) {
      notFound(request);
      return;
    }

    ok(quote, request);
  }
}
