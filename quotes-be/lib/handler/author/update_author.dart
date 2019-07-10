import 'dart:io';

import '../../domain/author/model.dart';
import '../../domain/author/service.dart';
import '../../common/tuple.dart';
import '../common.dart';
import '../common/form.dart';
import 'form.dart';
import 'params.dart';

class UpdateAuthorHandler extends Handler {
  AuthorService _authorService;

  UpdateAuthorHandler(this._authorService) : super();

  void execute(HttpRequest req, PathParams pathParams, UrlParams urlParams) =>
      parseForm(req, AuthorFormParser(true, true))
          .then((form) => Tuple2(form, AuthorIdParams(pathParams.getString("authorId"))))
          .then((tuple2) => Tuple2(tuple2.e1, tuple2.e2.validate()))
          .then((tuple2) => createAuthor(tuple2.e2, tuple2.e1))
          .then((author) => _authorService.update(author))
          .then((author) => ok(author, req))
          .catchError((e) => handleErrors(e, req));

  Author createAuthor(AuthorIdValidParams params, AuthorForm form) =>
      Author(params.authorId, form.name, form.description, nowUtc(), form.createdUtc);
}
