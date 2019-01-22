import 'dart:async';
import 'dart:io';

import '../../domain/common/model.dart';
import '../../domain/quote/service.dart';
import '../common.dart';
import '../common/form.dart';
import '../common/params.dart';

class FindQuotesHandler extends Handler {
  static final _URL = r"/quotes";

  QuoteService _quoteService;

  FindQuotesHandler(this._quoteService) : super(_URL, "GET") {}

  void execute(HttpRequest req, PathParams pathParams, UrlParams urlParams) =>
      Future.value(SearchParams(
              urlParams.getOptionalString("searchPhrase"),
              urlParams.getIntOrElse("limit", 2),
              urlParams.getIntOrElse("offset", 0)))
          .then((params) => params.validate())
          .then((params) => _quoteService.findQuotes(
              params.searchPhrase, PageRequest(params.limit, params.offset)))
          .then((books) => ok(books, req))
          .catchError((e) => handleErrors(e, req));
}
