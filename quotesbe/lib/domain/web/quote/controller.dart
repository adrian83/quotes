import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:logging/logging.dart';

import 'package:quotesbedomain/quote/service.dart';
import 'package:quotesbe/domain/quote/model/command.dart';
import 'package:quotesbe/domain/quote/model/query.dart';
import 'package:quotesbe/domain/web/common/request.dart';
import 'package:quotesbe/web/error.dart';
import 'package:quotesbe/web/response.dart';

class QuoteController {
  final Logger _logger = Logger('QuoteController');

  final QuoteService _quoteService;

  QuoteController(this._quoteService);

  List<ValidationRule> newQuoteValidationRules = [
    ValidationRule("text", "Text cannot be empty", emptyString),
  ];

  List<ValidationRule> updateQuoteValidationRules = [
    ValidationRule("text", "Text cannot be empty", emptyString),
  ];

  Future<Response> search(Request request) async {
    var query = extractSearchQuery(request);

    return _quoteService
        .findQuotes(query)
        .then((page) => jsonResponseOk(page));
  }

    Future<Response> searchBookQuotes(Request request, String authorId, String bookId) async {
    var query = ListQuotesFromBookQuery(authorId, bookId, extractPageRequest(request));


    return _quoteService
    .findBookQuotes(query)
        .then((page) => jsonResponseOk(page));
  }

  Future<Response> store(
    Request request,
    String authorId,
    String bookId,
  ) async {
    var json = jsonDecode(await request.readAsString()) as Map;

    var violations = validate(newQuoteValidationRules, json);
    if (violations.isNotEmpty) {
      _logger.warning("[save quote] validation error: $violations");
      return responseBadRequest(violations);
    }

    var command = NewQuoteCommand(authorId, bookId, json["text"]);

    return _quoteService
        .save(command)
        .then((quote) => jsonResponseOk(quote));
  }

  Future<Response> update(
    Request request,
    String authorId,
    String bookId,
    String quoteId,
  ) async {
    var json = jsonDecode(await request.readAsString()) as Map;

    var violations = validate(updateQuoteValidationRules, json);
    if (violations.isNotEmpty) {
      _logger.warning("[update quote] validation error: $violations");
      return responseBadRequest(violations);
    }

    var command = UpdateQuoteCommand(authorId, bookId, quoteId, json["text"]);

    return _quoteService
        .update(command)
        .then((quote) => jsonResponseOk(quote));
  }

  Future<Response> find(
    Request request,
    String authorId,
    String bookId,
    String quoteId,
  ) =>
      _quoteService
          .find(FindQuoteQuery(authorId, bookId, quoteId))
          .then((quote) => jsonResponseOk(quote));

  Future<Response> delete(
    Request request,
    String authorId,
    String bookId,
    String quoteId,
  ) =>
      _quoteService
          .delete(DeleteQuoteCommand(authorId, bookId, quoteId))
          .then((_) => emptyResponseOk());

  Future<Response> listEvents(
    Request request,
    String authorId,
    String bookId,
    String quoteId,
  ) =>
      _quoteService.listEvents(ListEventsByQuoteQuery(authorId, bookId, quoteId, extractPageRequest(request)))
          .then((page) => jsonResponseOk(page));
}
