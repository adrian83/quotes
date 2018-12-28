import 'dart:io';

import '../common.dart';

import '../common/form.dart';

import '../../domain/book/service.dart';
import '../../domain/common/model.dart';

class BookEventsHandler extends Handler {
  static final _URL = r"/authors/{authorId}/books/{bookId}/events";

  BookService _bookService;

  BookEventsHandler(this._bookService) : super(_URL, "GET") {}

  void execute(
      HttpRequest request, PathParams pathParams, UrlParams urlParams) {
    var limit = urlParams.getIntOrElse("limit", 2);
    var offset = urlParams.getIntOrElse("offset", 0);

    var authorIdOrErr = pathParams.getString("authorId");
    var bookIdOrErr = pathParams.getString("bookId");

    var errors = ParseElem.errors([limit, offset, authorIdOrErr, bookIdOrErr]);
    if (errors.length > 0) {
      badRequest(errors, request);
      return;
    }

    var req = PageRequest(limit.value, offset.value);

    _bookService.listEvents(authorIdOrErr.value, bookIdOrErr.value, req)
        .then((authors) => ok(authors, request))
        .catchError((e) => handleErrors(e, request));
  }
}
