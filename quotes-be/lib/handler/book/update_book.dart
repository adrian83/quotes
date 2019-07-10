import 'dart:io';

import '../../domain/book/model.dart';
import '../../domain/book/service.dart';
import '../../common/tuple.dart';
import '../common.dart';
import '../common/form.dart';
import 'params.dart';
import 'form.dart';

class UpdateBookHandler extends Handler {
  BookService _bookService;

  UpdateBookHandler(this._bookService) : super();

  void execute(HttpRequest req, PathParams pathParams, UrlParams urlParams) =>
      parseForm(req, BookFormParser(true, true))
          .then((form) => Tuple2(form, BookIdParams(pathParams.getString("authorId"), pathParams.getString("bookId"))))
          .then((tuple2) => Tuple2(tuple2.e1, tuple2.e2.validate()))
          .then((tuple2) => createBook(tuple2.e2, tuple2.e1))
          .then((book) => _bookService.update(book))
          .then((book) => ok(book, req))
          .catchError((e) => handleErrors(e, req));

  Book createBook(BookIdValidParams params, BookForm form) =>
      Book(params.bookId, form.title, form.description, params.authorId, nowUtc(), form.createdUtc);
}
