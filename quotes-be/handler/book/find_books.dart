import 'dart:async';
import 'dart:io';

import '../../domain/book/service.dart';
import '../../domain/common/model.dart';
import '../common.dart';
import '../common/form.dart';
import '../common/params.dart';

class FindBooksHandler extends Handler {
  static final _URL = r"/books";

  BookService _bookService;

  FindBooksHandler(this._bookService) : super(_URL, "GET") {}

  void execute(HttpRequest req, PathParams pathParams, UrlParams urlParams) {
    var params = Params()
      ..limitParam = urlParams.getIntOrElse("limit", 2)
      ..offsetParam = urlParams.getIntOrElse("offset", 0)
      ..searchPhraseParam = urlParams.getOptionalString("searchPhrase");

    Future.value(params)
        .then((params) => params.validate())
        .then((params) => _bookService.findBooks(
            params.searchPhrase, PageRequest(params.limit, params.offset)))
        .then((books) => ok(books, req))
        .catchError((e) => handleErrors(e, req));
  }
}
