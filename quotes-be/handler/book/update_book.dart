import 'dart:io';

import '../../domain/book/model.dart';
import '../../domain/book/service.dart';
import '../../tools/tuple.dart';
import '../common.dart';
import '../common/form.dart';
import '../common/params.dart';
import 'form.dart';

class UpdateBookHandler extends Handler {
  static final _URL = r"/authors/{authorId}/books/{bookId}";

  BookService _bookService;

  UpdateBookHandler(this._bookService) : super(_URL, "PUT");

  void execute(HttpRequest req, PathParams pathParams, UrlParams urlParams) {
    var params = Params()
      ..authorIdParam = pathParams.getString("authorId")
      ..bookIdParam = pathParams.getString("bookId");

    parseForm(req, BookFormParser(true, true))
        .then((form) => Tuple2(form, params))
        .then((tuple2) => Tuple2(tuple2.e1, tuple2.e2.validate()))
        .then((tuple2) => createBook(tuple2.e2, tuple2.e1))
        .then((book) => _bookService.update(book))
        .then((book) => ok(book, req))
        .catchError((e) => handleErrors(e, req));
  }

  Book createBook(Params params, BookForm form) => Book(params.bookId,
      form.title, form.description, params.authorId, nowUtc(), form.createdUtc);
}
