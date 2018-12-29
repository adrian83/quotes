import 'dart:io';

import '../../domain/book/model.dart';
import '../../domain/book/service.dart';
import '../../tools/tuple.dart';
import '../common.dart';
import '../common/form.dart';
import '../common/params.dart';
import 'form.dart';

class AddBookHandler extends Handler {
  static final _URL = r"/authors/{authorId}/books";

  BookService _bookService;

  AddBookHandler(this._bookService) : super(_URL, "POST");

  void execute(HttpRequest req, PathParams pathParams, UrlParams urlParams) {
    var params = Params()..authorIdParam = pathParams.getString("authorId");

    parseForm(req, BookFormParser(false, false))
        .then((form) => Tuple2(form, params))
        .then((tuple2) => Tuple2(tuple2.e1, tuple2.e2.validate()))
        .then((tuple2) => fromForm(tuple2.e2, tuple2.e1))
        .then((book) => _bookService.save(book))
        .then((book) => created(book, req))
        .catchError((e) => handleErrors(e, req));
  }

  Book fromForm(Params params, BookForm form) => Book(
      null, form.title, form.description, params.authorId, nowUtc(), nowUtc());
}
