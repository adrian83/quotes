import 'dart:async';
import 'dart:io';

import '../../domain/author/service.dart';
import '../../domain/common/model.dart';
import '../common.dart';
import '../response.dart';
import '../error_handler.dart';
import '../common/form.dart';
import '../common/params.dart';

class FindAuthorsHandler extends Handler {
  AuthorService _authorService;

  FindAuthorsHandler(this._authorService) : super();

  void execute(HttpRequest req, PathParams pathParams, UrlParams urlParams) => Future.value(SearchParams(
          urlParams.getOptionalString("searchPhrase"),
          urlParams.getIntOrElse("limit", 2),
          urlParams.getIntOrElse("offset", 0)))
      .then((params) => params.validate())
      .then((params) => _authorService.findAuthors(params.searchPhrase, PageRequest(params.limit, params.offset)))
      .then((authors) => ok(authors, req))
      .catchError((e) => handleErrors(e, req));
}
