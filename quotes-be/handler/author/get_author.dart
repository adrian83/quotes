import 'dart:async';
import 'dart:io';

import './../common.dart';
import '../../domain/author/service.dart';
import '../common/form.dart';
import '../common/params.dart';

class GetAuthorHandler extends Handler {
  static final _URL = r"/authors/{authorId}";

  AuthorService _authorService;

  GetAuthorHandler(this._authorService) : super(_URL, "GET");

  void execute(HttpRequest req, PathParams pathParams, UrlParams urlParams) {
    var params = Params()..authorIdParam = pathParams.getString("authorId");

    Future.value(params)
        .then((params) => params.validate())
        .then((params) => _authorService.find(params.authorId))
        .then((a) => ok(a, req))
        .catchError((e) => handleErrors(e, req));
  }
}
