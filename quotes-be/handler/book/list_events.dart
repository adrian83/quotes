import 'dart:async';
import 'dart:io';

import '../../domain/book/service.dart';
import '../../domain/common/model.dart';
import '../common.dart';
import '../common/form.dart';
import '../common/params.dart';

class BookEventsHandler extends Handler {
  static final _URL = r"/authors/{authorId}/books/{bookId}/events";

  BookService _bookService;

  BookEventsHandler(this._bookService) : super(_URL, "GET") {}

  void execute(HttpRequest req, PathParams pathParams, UrlParams urlParams) {
    var params = Params()
      ..authorIdParam = pathParams.getString("authorId")
      ..bookIdParam = pathParams.getString("bookId")
      ..limitParam = urlParams.getIntOrElse("limit", 2)
      ..offsetParam = urlParams.getIntOrElse("offset", 0);

    Future.value(params)
        .then((params) => params.validate())
        .then((params) => _bookService.listEvents(params.authorId,
            params.bookId, PageRequest(params.limit, params.offset)))
        .then((authors) => ok(authors, req))
        .catchError((e) => handleErrors(e, req));
  }
}
