import 'dart:async';
import 'dart:io';

import '../../domain/book/service.dart';
import '../../domain/common/model.dart';
import '../common.dart';
import '../common/form.dart';
import 'params.dart';

class BookEventsHandler extends Handler {
  BookService _bookService;

  BookEventsHandler(this._bookService) : super();

  void execute(HttpRequest req, PathParams pathParams, UrlParams urlParams) =>
      Future.value(ListByBookParams(
              pathParams.getString("authorId"),
              pathParams.getString("bookId"),
              urlParams.getIntOrElse("limit", 2),
              urlParams.getIntOrElse("offset", 0)))
          .then((params) => params.validate())
          .then((params) => _bookService.listEvents(params.authorId,
              params.bookId, PageRequest(params.limit, params.offset)))
          .then((authors) => ok(authors, req))
          .catchError((e) => handleErrors(e, req));
}
