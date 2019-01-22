import 'dart:async';
import 'dart:io';

import './../common.dart';
import '../../domain/book/service.dart';
import '../common.dart';
import '../common/form.dart';
import 'params.dart';

class DeleteBookHandler extends Handler {
  static final _URL = r"/authors/{authorId}/books/{bookId}";

  BookService _bookService;

  DeleteBookHandler(this._bookService) : super(_URL, "DELETE");

  void execute(HttpRequest req, PathParams pathParams, UrlParams urlParams) =>
      Future.value(BookIdParams(
              pathParams.getString("authorId"), pathParams.getString("bookId")))
          .then((params) => params.validate())
          .then((params) => _bookService.delete(params.bookId))
          .then((_) => ok(null, req))
          .catchError((e) => handleErrors(e, req));
}
