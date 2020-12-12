import 'dart:io';

import 'form.dart';
import '../error.dart';
import '../../../domain/quote/service.dart';
import '../../web/form.dart';
import '../../web/param.dart';
import '../../web/response.dart';



class QuoteHandler {
  QuoteService _quoteService;

  QuoteHandler(this._quoteService) : super();

  void persist(HttpRequest req, Params params) => readForm(req)
      .then((form) => PersistQuoteParams(form, params))
      .then((persistParams) => _quoteService.save(persistParams.toQuote()))
      .then((quote) => created(quote, req))
      .catchError((e) => handleErrors(e, req));

  void delete(HttpRequest req, Params params) => 
      Future.value(DeleteQuoteParams(params))
          .then((deleteParams) => _quoteService.delete(deleteParams.getQuoteId()))
          .then((_) => ok(null, req))
          .catchError((e) => handleErrors(e, req));

  void search(HttpRequest req, Params params) => readForm(req)
      
          .then((form) => SearchQuotesParams(form, params))
          .then((searchParams) => _quoteService.findQuotes(searchParams.toSearchQuoteRequest()))
          .then((books) => ok(books, req))
          .catchError((e) => handleErrors(e, req));

  void find(HttpRequest req, Params params) =>
      Future.value(FindQuoteParams(params))
          .then((findParams) => _quoteService.find(findParams.getQuoteId()))
          .then((q) => ok(q, req))
          .catchError((e) => handleErrors(e, req));

  void listEvents(HttpRequest req, Params params) => Future.value(ListEventsByQuoteParams(params))
      .then((eventsParams) => _quoteService.listEvents(eventsParams.toListEventsByQuoteRequest()))
      .then((events) => ok(events, req))
      .catchError((e) => handleErrors(e, req));

  void listByBook(HttpRequest req, Params params) => Future.value(ListQuotesFromBookParams(params))
      .then((listParams) => _quoteService.findBookQuotes(listParams.toListQuotesFromBookRequest()))
      .then((p) => ok(p, req))
      .catchError((e) => handleErrors(e, req));

  void update(HttpRequest req, Params params) => readForm(req)
      .then((form) => UpdateQuoteParams(form, params))
      .then((updateParams) => _quoteService.update(updateParams.toQuote()))
      .then((quote) => ok(quote, req))
      .catchError((e) => handleErrors(e, req));
}
