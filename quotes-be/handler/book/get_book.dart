import 'dart:async';
import 'dart:io';

import '../../domain/book/service.dart';
import '../common.dart';
import '../common/form.dart';
import 'params.dart';

class GetBookHandler extends Handler {
  BookService _bookService;

  GetBookHandler(this._bookService) : super();

  void execute(HttpRequest req, PathParams pathParams, UrlParams urlParams) =>
      Future.value(BookIdParams(
              pathParams.getString("authorId"), pathParams.getString("bookId")))
          .then((params) => params.validate())
          .then((params) => _bookService.find(params.bookId))
          .then((book) => ok(book, req))
          .catchError((e) => handleErrors(e, req));
}
