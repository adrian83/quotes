import 'dart:io';

import '../common.dart';
import '../common/form.dart';

import '../../domain/book/service.dart';
import '../../domain/common/model.dart';

class ListBooksHandler extends Handler {
  static final _URL = r"/authors/{authorId}/books";

  BookService _bookService;

  ListBooksHandler(this._bookService) : super(_URL, "GET");

  void execute(
      HttpRequest request, PathParams pathParams, UrlParams urlParams) {
    var idOrErr = pathParams.getString("authorId");
    var limit = urlParams.getIntOrElse("limit", 2);
    var offset = urlParams.getIntOrElse("offset", 0);

    var errors = ParseElem.errors([idOrErr, limit, offset]);
    if (errors.length > 0) {
      badRequest(errors, request);
      return;
    }

    var req = PageRequest(limit.value, offset.value);

    _bookService
        .findBooks(idOrErr.value, req)
        .then((books) => ok(books, request))
        .catchError((e) => handleErrors(e, request));
  }
}
