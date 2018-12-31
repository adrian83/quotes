import 'dart:async';
import 'dart:io';

import '../../domain/author/service.dart';
import '../../domain/common/model.dart';
import '../common.dart';
import '../common/form.dart';
import '../common/params.dart';

class AuthorEventsHandler extends Handler {
  static final _URL = r"/authors/{authorId}/events";

  AuthorService _authorService;

  AuthorEventsHandler(this._authorService) : super(_URL, "GET") {}

  void execute(HttpRequest req, PathParams pathParams, UrlParams urlParams) {
    var params = Params()
      ..authorIdParam = pathParams.getString("authorId")
      ..limitParam = urlParams.getIntOrElse("limit", 2)
      ..offsetParam = urlParams.getIntOrElse("offset", 0);

    Future.value(params)
        .then((params) => params.validate())
        .then((params) => _authorService.listEvents(
            params.authorId, PageRequest(params.limit, params.offset)))
        .then((authors) => ok(authors, req))
        .catchError((e) => handleErrors(e, req));
  }
}
