import 'dart:io';

import '../../domain/quote/model.dart';
import '../../domain/quote/service.dart';
import '../../common/tuple.dart';
import '../common/form.dart';
import '../response.dart';
import '../error.dart';
import '../form.dart';
import 'form.dart';
import 'params.dart';
import '../book/params.dart';
import '../../common/time.dart';
import '../../domain/common/model.dart';
import '../common/params.dart';


class QuoteHandler {
  QuoteService _quoteService;

  QuoteHandler(this._quoteService) : super();

  void persist(HttpRequest req, PathParams pathParams, UrlParams urlParams) =>
      parseForm(req, QuoteFormParser(false, false))
          .then((form) => Tuple2(
              form,
              BookIdParams(pathParams.getString("authorId"),
                  pathParams.getString("bookId"))))
          .then((tuple2) => Tuple2(tuple2.e1, tuple2.e2.validate()))
          .then((tuple2) => formToQuote(tuple2.e2, tuple2.e1))
          .then((quote) => _quoteService.save(quote))
          .then((quote) => created(quote, req))
          .catchError((e) => handleErrors(e, req));

  void delete(HttpRequest req, PathParams pathParams, UrlParams urlParams) =>
      Future.value(QuoteIdParams(pathParams.getString("authorId"),
              pathParams.getString("bookId"), pathParams.getString("quoteId")))
          .then((params) => params.validate())
          .then((params) => _quoteService.delete(params.quoteId))
          .then((_) => ok(null, req))
          .catchError((e) => handleErrors(e, req));

  void search(HttpRequest req, PathParams pathParams, UrlParams urlParams) =>
      Future.value(SearchParams(
              urlParams.getOptionalString("searchPhrase"),
              urlParams.getIntOrElse("limit", 2),
              urlParams.getIntOrElse("offset", 0)))
          .then((params) => params.validate())
          .then((params) => _quoteService.findQuotes(
              params.searchPhrase, PageRequest(params.limit, params.offset)))
          .then((books) => ok(books, req))
          .catchError((e) => handleErrors(e, req));

  void find(HttpRequest req, PathParams pathParams, UrlParams urlParams) =>
      Future.value(QuoteIdParams(pathParams.getString("authorId"),
              pathParams.getString("bookId"), pathParams.getString("quoteId")))
          .then((params) => params.validate())
          .then((params) => _quoteService.find(params.quoteId))
          .then((q) => ok(q, req))
          .catchError((e) => handleErrors(e, req));

  void listEvents(HttpRequest req, PathParams pathParams, UrlParams urlParams) =>
      Future.value(ListByQuoteParams(
              pathParams.getString("authorId"),
              pathParams.getString("bookId"),
              pathParams.getString("quoteId"),
              urlParams.getIntOrElse("limit", 2),
              urlParams.getIntOrElse("offset", 0)))
          .then((params) => params.validate())
          .then((params) => _quoteService.listEvents(
              params.authorId,
              params.bookId,
              params.quoteId,
              PageRequest(params.limit, params.offset)))
          .then((events) => ok(events, req))
          .catchError((e) => handleErrors(e, req));

  void listByBook(HttpRequest req, PathParams pathParams, UrlParams urlParams) =>
      Future.value(ListByBookParams(
              pathParams.getString("authorId"),
              pathParams.getString("bookId"),
              urlParams.getIntOrElse("limit", 2),
              urlParams.getIntOrElse("offset", 0)))
          .then((params) => params.validate())
          .then((params) => _quoteService.findBookQuotes(
              params.bookId, PageRequest(params.limit, params.offset)))
          .then((p) => ok(p, req))
          .catchError((e) => handleErrors(e, req));

  void update(HttpRequest req, PathParams pathParams, UrlParams urlParams) =>
      parseForm(req, QuoteFormParser(true, true))
          .then((form) => Tuple2(
              form,
              QuoteIdParams(
                  pathParams.getString("authorId"),
                  pathParams.getString("bookId"),
                  pathParams.getString("quoteId"))))
          .then((tuple2) => Tuple2(tuple2.e1, tuple2.e2.validate()))
          .then((tuple2) => createQuote(tuple2.e2, tuple2.e1))
          .then((quote) => _quoteService.update(quote))
          .then((quote) => ok(quote, req))
          .catchError((e) => handleErrors(e, req));

  Quote createQuote(QuoteIdValidParams params, QuoteForm form) => Quote(
      params.quoteId,
      form.text,
      params.authorId,
      params.bookId,
      nowUtc(),
      form.createdUtc);

  Quote formToQuote(BookIdValidParams params, QuoteForm form) => Quote(
      null, form.text, params.authorId, params.bookId, nowUtc(), nowUtc());
}
