import 'dart:async';
import 'dart:io';

import './../common.dart';
import '../../domain/author/service.dart';
import '../common/form.dart';
import 'params.dart';

class GetAuthorHandler extends Handler {
  AuthorService _authorService;

  GetAuthorHandler(this._authorService) : super();

  void execute(HttpRequest req, PathParams pathParams, UrlParams urlParams) =>
      Future.value(AuthorIdParams(pathParams.getString("authorId")))
          .then((params) => params.validate())
          .then((params) => _authorService.find(params.authorId))
          .then((a) => ok(a, req))
          .catchError((e) => handleErrors(e, req));
}
