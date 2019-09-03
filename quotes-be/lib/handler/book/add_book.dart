import 'dart:io';

import '../../domain/book/model.dart';
import '../../domain/book/service.dart';
import '../../common/tuple.dart';
import '../common.dart';
import '../common/form.dart';
import '../response.dart';
import '../error_handler.dart';
import '../form.dart';
import 'form.dart';
import '../author/params.dart';

class AddBookHandler extends Handler {
  BookService _bookService;

  AddBookHandler(this._bookService) : super();

  void execute(HttpRequest req, PathParams pathParams, UrlParams urlParams) =>
      parseForm(req, BookFormParser(false, false))
          .then((form) => Tuple2(form, AuthorIdParams(pathParams.getString("authorId"))))
          .then((tuple2) => Tuple2(tuple2.e1, tuple2.e2.validate()))
          .then((tuple2) => fromForm(tuple2.e2, tuple2.e1))
          .then((book) => _bookService.save(book))
          .then((book) => created(book, req))
          .catchError((e) => handleErrors(e, req));

  Book fromForm(AuthorIdValidParams params, BookForm form) =>
      Book(null, form.title, form.description, params.authorId, nowUtc(), nowUtc());
}
