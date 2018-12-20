import 'dart:io';

import '../common.dart';

import '../common/form.dart';

import '../../domain/book/service.dart';
import '../../domain/common/model.dart';

class FindBooksHandler extends Handler {
  static final _URL = r"/books";

  BookService _bookService;

  FindBooksHandler(this._bookService) : super(_URL, "GET") {}

  void execute(
      HttpRequest request, PathParams pathParams, UrlParams urlParams) {
    var limit = urlParams.getIntOrElse("limit", 2);
    var offset = urlParams.getIntOrElse("offset", 0);

    var errors = ParseElem.errors([limit, offset]);
    if (errors.length > 0) {
      badRequest(errors, request);
      return;
    }

    var searchPhrase = urlParams.getOptionalString("searchPhrase").value;
    var req = PageRequest(limit.value, offset.value);

    _bookService
        .findBooks(searchPhrase, req)
        .then((books) => ok(books, request))
        .catchError((e) => handleErrors(e, request));
    
  }
}
