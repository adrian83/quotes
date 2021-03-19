import 'dart:io';

import 'package:logging/logging.dart';

import 'form.dart';
import '../error.dart';
import '../../../domain/quote/service.dart';
import '../../../infrastructure/web/form.dart';
import '../../../infrastructure/web/param.dart';
import '../../../infrastructure/web/response.dart';

class QuoteHandler {
  static final Logger _logger = Logger('BookHandler');

  QuoteService _quoteService;

  QuoteHandler(this._quoteService) : super();

  void persist(HttpRequest req, Params params) => Future.value(params)
      .then((_) => _logger.info("persist quote request with params: $params"))
      .then((_) => readForm(req))
      .then((form) => PersistQuoteParams(form, params))
      .then((persistParams) => _quoteService.save(persistParams.toQuote()))
      .then((quote) => created(quote, req))
      .catchError((e) => handleErrors(e, req));

  void delete(HttpRequest req, Params params) => Future.value(params)
      .then((_) => _logger.info("delete quote request with params: $params"))
      .then((_) => DeleteQuoteParams(params))
      .then((deleteParams) => _quoteService.delete(deleteParams.getQuoteId()))
      .then((_) => ok(null, req))
      .catchError((e) => handleErrors(e, req));

  void search(HttpRequest req, Params params) => Future.value(params)
      .then((_) => _logger.info("search for quotes request with params: $params"))
      .then((_) => SearchParams(params))
      .then((searchParams) => _quoteService.findQuotes(searchParams.toSearchEntityRequest()))
      .then((books) => ok(books, req))
      .catchError((e) => handleErrors(e, req));

  void find(HttpRequest req, Params params) => Future.value(params)
      .then((_) => _logger.info("find quote request with params: $params"))
      .then((_) => FindQuoteParams(params))
      .then((findParams) => _quoteService.find(findParams.getQuoteId()))
      .then((q) => ok(q, req))
      .catchError((e) => handleErrors(e, req));

  void listEvents(HttpRequest req, Params params) => Future.value(params)
      .then((_) => _logger.info("list quote events request with params: $params"))
      .then((_) => ListEventsByQuoteParams(params))
      .then((eventsParams) => _quoteService.listEvents(eventsParams.toListEventsByQuoteRequest()))
      .then((events) => ok(events, req))
      .catchError((e) => handleErrors(e, req));

  void listByBook(HttpRequest req, Params params) => Future.value(params)
      .then((_) => _logger.info("list quotes by book request with params: $params"))
      .then((_) => ListQuotesFromBookParams(params))
      .then((listParams) => _quoteService.findBookQuotes(listParams.toListQuotesFromBookRequest()))
      .then((p) => ok(p, req))
      .catchError((e) => handleErrors(e, req));

  void update(HttpRequest req, Params params) => Future.value(params)
      .then((_) => _logger.info("update quote request with params: $params"))
      .then((_) => readForm(req))
      .then((form) => UpdateQuoteParams(form, params))
      .then((updateParams) => _quoteService.update(updateParams.toQuote()))
      .then((quote) => ok(quote, req))
      .catchError((e) => handleErrors(e, req));
}
