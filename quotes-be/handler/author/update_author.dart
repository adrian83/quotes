import 'dart:io';

import '../../domain/author/model.dart';
import '../../domain/author/service.dart';
import '../../tools/tuple.dart';
import '../common.dart';
import '../common/form.dart';
import '../common/params.dart';
import 'form.dart';

class UpdateAuthorHandler extends Handler {
  static final _URL = r"/authors/{authorId}";

  AuthorService _authorService;

  UpdateAuthorHandler(this._authorService) : super(_URL, "PUT") {}

  void execute(HttpRequest req, PathParams pathParams, UrlParams urlParams) {
    var params = Params()..authorIdParam = pathParams.getString("authorId");

    parseForm(req, AuthorFormParser(true, true))
        .then((form) => Tuple2(form, params))
        .then((tuple2) => Tuple2(tuple2.e1, tuple2.e2.validate()))
        .then((tuple2) => createAuthor(tuple2.e2, tuple2.e1))
        .then((author) => _authorService.update(author))
        .then((author) => ok(author, req))
        .catchError((e) => handleErrors(e, req));
  }

  Author createAuthor(Params params, AuthorForm form) => Author(
      params.authorId, form.name, form.description, nowUtc(), form.createdUtc);
}
