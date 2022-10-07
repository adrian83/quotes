import 'dart:async';

import 'package:http/browser_client.dart';

import 'package:quotesfe2/domain/quote/model.dart';
import 'package:quotesfe2/domain/quote/event.dart';
import 'package:quotesfe2/domain/common/service.dart';
import 'package:quotesfe2/domain/common/page.dart';
import 'package:quotesfe2/tools/config.dart';

class QuoteService extends Service<Quote> {
  final Config _config;

  QuoteService(BrowserClient http, this._config) : super(http);

  Future<QuotesPage> listBookQuotes(
      String authorId, String bookId, PageRequest request) {
    var url =
        "${_config.beHost}/authors/$authorId/books/$bookId/quotes?${pageRequestToUrlParams(request)}";
    return getEntity(url).then((json) => QuotesPage.fromJson(json));
  }

  Future<QuotesPage> listQuotes(String searchPhrase, PageRequest request) {
    var url = "${_config.beHost}/quotes?${pageRequestToUrlParams(request)}";
    url = appendUrlParam(url, "searchPhrase", searchPhrase);
    return getEntity(url).then((json) => QuotesPage.fromJson(json));
  }

  Future<QuoteEventsPage> listEvents(
      String authorId, String bookId, String quoteId, PageRequest request) {
    var url =
        "${_config.beHost}/authors/$authorId/books/$bookId/quotes/$quoteId/events?${pageRequestToUrlParams(request)}";
    return getEntity(url).then((json) => QuoteEventsPage.fromJson(json));
  }

  Future<Quote> find(String authorId, String bookId, String quoteId) {
    var url =
        "${_config.beHost}/authors/$authorId/books/$bookId/quotes/$quoteId";
    return getEntity(url).then((json) => Quote.fromJson(json));
  }

  Future<Quote> update(Quote quote) {
    var url =
        "${_config.beHost}/authors/${quote.authorId}/books/${quote.bookId}/quotes/${quote.id}";
    return updateEntity(url, quote).then((json) => Quote.fromJson(json));
  }

  Future<Quote> create(Quote quote) {
    var url =
        "${_config.beHost}/authors/${quote.authorId}/books/${quote.bookId}/quotes";
    return createEntity(url, quote).then((json) => Quote.fromJson(json));
  }

  Future<String> delete(String authorId, String bookId, String quoteId) {
    var url =
        "${_config.beHost}/authors/$authorId/books/$bookId/quotes/$quoteId";
    return deleteEntity(url).then((_) => quoteId);
  }
}
