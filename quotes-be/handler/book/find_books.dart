import 'dart:async';
import 'dart:io';

import '../../domain/book/service.dart';
import '../../domain/common/model.dart';
import '../common.dart';
import '../common/form.dart';
import '../common/params.dart';

class FindBooksHandler extends Handler {
  BookService _bookService;

  FindBooksHandler(this._bookService) : super();

  void execute(HttpRequest req, PathParams pathParams, UrlParams urlParams) =>
      Future.value(SearchParams(
              urlParams.getOptionalString("searchPhrase"),
              urlParams.getIntOrElse("limit", 2),
              urlParams.getIntOrElse("offset", 0)))
          .then((params) => params.validate())
          .then((params) => _bookService.findBooks(
              params.searchPhrase, PageRequest(params.limit, params.offset)))
          .then((books) => ok(books, req))
          .catchError((e) => handleErrors(e, req));
}
