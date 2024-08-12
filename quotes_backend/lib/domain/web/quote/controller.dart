import 'dart:convert';

import 'package:shelf/shelf.dart';

import 'package:quotes_backend/domain/quote/service.dart';
import 'package:quotes_backend/domain/quote/model/command.dart';
import 'package:quotes_backend/domain/quote/model/query.dart';
import 'package:quotes_backend/domain/web/common/request.dart';
import 'package:quotes_backend/domain/web/common/response.dart';
import 'package:quotes_backend/web/error.dart';
import 'package:quotes_backend/web/response.dart';

class QuoteController {
  final QuoteService _quoteService;

  QuoteController(this._quoteService);

  List<ValidationRule> newQuoteValidationRules = [
    ValidationRule("text", "Text cannot be empty", emptyString),
  ];

  List<ValidationRule> updateQuoteValidationRules = [
    ValidationRule("text", "Text cannot be empty", emptyString),
  ];

  Future<Response> search(Request request) async => Future.value(request)
      .then((req) => extractSearchQuery(req))
      .then((query) => _quoteService.findQuotes(query))
      .then((page) => jsonResponseOk(page))
      .onError<Exception>((error, stackTrace) => handleError(error));

  Future<Response> searchBookQuotes(Request request, String authorId, String bookId) async => Future.value(request)
      .then((req) => extractPageRequest(req))
      .then((page) => ListQuotesFromBookQuery(authorId, bookId, page))
      .then((query) => _quoteService.findBookQuotes(query))
      .then((page) => jsonResponseOk(page))
      .onError<Exception>((error, stackTrace) => handleError(error));

  Future<Response> store(Request request, String authorId, String bookId) async => Future.value(request)
      .then((req) => req.readAsString())
      .then((body) => jsonDecode(body) as Map)
      .then((json) => validate(newQuoteValidationRules, json))
      .then((json) => NewQuoteCommand(authorId, bookId, json["text"]))
      .then((command) => _quoteService.save(command))
      .then((quote) => jsonResponseOk(quote))
      .onError<Exception>((error, stackTrace) => handleError(error));

  Future<Response> update(Request request, String authorId, String bookId, String quoteId) async => Future.value(request)
      .then((req) => req.readAsString())
      .then((body) => jsonDecode(body) as Map)
      .then((json) => validate(updateQuoteValidationRules, json))
      .then((json) => UpdateQuoteCommand(authorId, bookId, quoteId, json["text"]))
      .then((command) => _quoteService.update(command))
      .then((quote) => jsonResponseOk(quote))
      .onError<Exception>((error, stackTrace) => handleError(error));

  Future<Response> find(Request request, String authorId, String bookId, String quoteId) => Future.value(FindQuoteQuery(authorId, bookId, quoteId))
      .then((query) => _quoteService.find(query))
      .then((quote) => jsonResponseOk(quote))
      .onError<Exception>((error, stackTrace) => handleError(error));

  Future<Response> delete(Request request, String authorId, String bookId, String quoteId) => Future.value(DeleteQuoteCommand(authorId, bookId, quoteId))
      .then((command) => _quoteService.delete(command))
      .then((_) => emptyResponseOk())
      .onError<Exception>((error, stackTrace) => handleError(error));

  Future<Response> listEvents(Request request, String authorId, String bookId, String quoteId) => Future.value(request)
      .then((req) => extractPageRequest(req))
      .then((page) => ListEventsByQuoteQuery(authorId, bookId, quoteId, page))
      .then((query) => _quoteService.listEvents(query))
      .then((page) => jsonResponseOk(page))
      .onError<Exception>((error, stackTrace) => handleError(error));
}
