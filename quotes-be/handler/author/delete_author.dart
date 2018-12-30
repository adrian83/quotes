import 'dart:async';
import 'dart:io';

import './../common.dart';
import '../../domain/author/service.dart';
import '../common/form.dart';
import '../common/params.dart';

class DeleteAuthorHandler extends Handler {
  static final _URL = r"/authors/{authorId}";

  AuthorService _authorService;

  DeleteAuthorHandler(this._authorService) : super(_URL, "DELETE");

  void execute(HttpRequest req, PathParams pathParams, UrlParams urlParams) {
    var params = Params()..authorIdParam = pathParams.getString("authorId");

    Future.value(params)
        .then((params) => params.validate())
        .then((params) => _authorService.delete(params.authorId))
        .then((_) => ok(null, req))
        .catchError((e) => handleErrors(e, req));
  }
}
