import 'dart:io';

import 'form.dart';
import '../error.dart';
import '../../../common/tuple.dart';
import '../../../domain/quote/model.dart';
import '../../../domain/quote/service.dart';
import '../../../domain/common/model.dart';
import '../../web/form.dart';
import '../../web/param.dart';
import '../../web/response.dart';


var requiredAuthorId = ParamData("authorId", "authorId cannot be empty");
var requiredBookId = ParamData("bookId", "bookId cannot be empty");
var requiredQuoteId = ParamData("quoteId", "quoteId cannot be empty");
var optionalSearchPhrase = ParamData("searchPhrase", "");
var positivePageLimit = ParamData("limit", "limit should be a positive integer");
var positivePageOffset = ParamData("offset", "offset should be a positive integer");


class QuoteHandler {
  QuoteService _quoteService;

  QuoteHandler(this._quoteService) : super();

  void persist(HttpRequest req, Params params) =>
      parseForm(req, NewQuoteFormParser())
          .then((form) => Tuple2(form, PathParam2(params, notEmptyString, requiredAuthorId, notEmptyString, requiredBookId)))
          .then((tuple2) => Tuple2(tuple2.e1, tuple2.e2.transform()))
          .then((tuple2) => formToQuote(tuple2.e2, tuple2.e1))
          .then((quote) => _quoteService.save(quote))
          .then((quote) => created(quote, req))
          .catchError((e) => handleErrors(e, req)); 

  void delete(HttpRequest req, Params params) =>
      Future.value(PathParam3(params, notEmptyString, requiredAuthorId, notEmptyString, requiredBookId, notEmptyString, requiredQuoteId))
          .then((params) => params.transform())
          .then((params) => _quoteService.delete(params.e3))
          .then((_) => ok(null, req))
          .catchError((e) => handleErrors(e, req));

  void search(HttpRequest req, Params params) =>
      Future.value(PathParam3(params, optionalString, optionalSearchPhrase, positiveInteger, positivePageLimit, positiveInteger, positivePageOffset))
          .then((params) => params.transform())
          .then((params) => _quoteService.findQuotes(
              params.e1, PageRequest(params.e2, params.e3)))
          .then((books) => ok(books, req))
          .catchError((e) => handleErrors(e, req));

  void find(HttpRequest req, Params params) =>
      Future.value(PathParam3(params, notEmptyString, requiredAuthorId, notEmptyString, requiredBookId, notEmptyString, requiredQuoteId))
          .then((params) => params.transform())
          .then((params) => _quoteService.find(params.e3))
          .then((q) => ok(q, req))
          .catchError((e) => handleErrors(e, req));

  void listEvents(HttpRequest req, Params params) =>
      Future.value(PathParam5(params, notEmptyString, requiredAuthorId, notEmptyString, requiredBookId, notEmptyString, requiredQuoteId, positiveInteger, positivePageLimit, positiveInteger, positivePageOffset))
          .then((params) => params.transform())
          .then((params) => _quoteService.listEvents(
              params.e1,
              params.e2,
              params.e3,
              PageRequest(params.e4, params.e5)))
          .then((events) => ok(events, req))
          .catchError((e) => handleErrors(e, req));

  void listByBook(HttpRequest req, Params params) =>
      Future.value(PathParam4(params, notEmptyString, requiredAuthorId, notEmptyString, requiredBookId, positiveInteger, positivePageLimit, positiveInteger, positivePageOffset))
          .then((params) => params.transform())
          .then((params) => _quoteService.findBookQuotes(
              params.e2, PageRequest(params.e3, params.e4)))
          .then((p) => ok(p, req))
          .catchError((e) => handleErrors(e, req));

  void update(HttpRequest req, Params params) =>
      parseForm(req, NewQuoteFormParser())
          .then((form) => Tuple2(
              form, PathParam3(params, notEmptyString, requiredAuthorId, notEmptyString, requiredBookId, notEmptyString, requiredQuoteId)))
          .then((tuple2) => Tuple2(tuple2.e1, tuple2.e2.transform()))
          .then((tuple2) => createQuote(tuple2.e2, tuple2.e1))
          .then((quote) => _quoteService.update(quote))
          .then((quote) => ok(quote, req))
          .catchError((e) => handleErrors(e, req));

  Quote createQuote(Tuple3<String, String, String> params, NewQuoteForm form) => 
  Quote.update(params.e3, form.text, params.e1, params.e2);

  Quote formToQuote(Tuple2<String, String> params, NewQuoteForm form) => 
  Quote.create(form.text, params.e1, params.e2);
}
