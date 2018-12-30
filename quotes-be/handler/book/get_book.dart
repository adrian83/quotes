import 'dart:async';
import 'dart:io';

import '../../domain/book/service.dart';
import '../common.dart';
import '../common/form.dart';
import '../common/params.dart';

class GetBookHandler extends Handler {
  static final _URL = r"/authors/{authorId}/books/{bookId}";

  BookService _bookService;

  GetBookHandler(this._bookService) : super(_URL, "GET");

  void execute(HttpRequest req, PathParams pathParams, UrlParams urlParams) {
    var params = Params()
      ..authorIdParam = pathParams.getString("authorId")
      ..bookIdParam = pathParams.getString("bookId");

    Future.value(params)
        .then((params) => params.validate())
        .then((params) => _bookService.find(params.bookId))
        .then((book) => ok(book, req))
        .catchError((e) => handleErrors(e, req));
  }
}
