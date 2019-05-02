import 'dart:async';
import 'dart:io';

import 'params.dart';
import '../common.dart';
import '../../domain/author/service.dart';
import '../common/form.dart';

class DeleteAuthorHandler extends Handler {
  AuthorService _authorService;

  DeleteAuthorHandler(this._authorService) : super();

  void execute(HttpRequest req, PathParams pathParams, UrlParams urlParams) =>
      Future.value(AuthorIdParams(pathParams.getString("authorId")))
          .then((params) => params.validate())
          .then((params) => _authorService.delete(params.authorId))
          .then((_) => ok(null, req))
          .catchError((e) => handleErrors(e, req));
}
