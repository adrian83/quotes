import 'dart:async';
import 'dart:io';

import '../../domain/book/service.dart';
import '../../domain/common/model.dart';
import '../common.dart';
import '../common/form.dart';
import '../author/params.dart';

class ListBooksHandler extends Handler {
  static final _URL = r"/authors/{authorId}/books";

  BookService _bookService;

  ListBooksHandler(this._bookService) : super(_URL, "GET");

  void execute(HttpRequest req, PathParams pathParams, UrlParams urlParams) =>
      Future.value(ListByAuthorParams(
              pathParams.getString("authorId"),
              urlParams.getIntOrElse("limit", 2),
              urlParams.getIntOrElse("offset", 0)))
          .then((params) => params.validate())
          .then((params) => _bookService.findAuthorBooks(
              params.authorId, PageRequest(params.limit, params.offset)))
          .then((books) => ok(books, req))
          .catchError((e) => handleErrors(e, req));
}
