import 'dart:async';
import 'dart:io';

import '../../domain/author/service.dart';
import '../../domain/common/model.dart';
import '../common.dart';
import '../common/form.dart';
import 'params.dart';

class AuthorEventsHandler extends Handler {
  AuthorService _authorService;

  AuthorEventsHandler(this._authorService) : super();

  void execute(HttpRequest req, PathParams pathParams, UrlParams urlParams) =>
      Future.value(ListByAuthorParams(
              pathParams.getString("authorId"),
              urlParams.getIntOrElse("limit", 2),
              urlParams.getIntOrElse("offset", 0)))
          .then((params) => params.validate())
          .then((params) => _authorService.listEvents(
              params.authorId, PageRequest(params.limit, params.offset)))
          .then((authors) => ok(authors, req))
          .catchError((e) => handleErrors(e, req));
}
