import 'dart:async';

import 'package:http/browser_client.dart';

import 'package:quotes_frontend/domain/quote/event.dart';
import 'package:quotes_frontend/domain/common/service.dart';
import 'package:quotes_frontend/tools/config.dart';
import 'package:quotes_common/domain/quote.dart';
import 'package:quotes_common/domain/page.dart';

class QuoteService extends Service<Quote> {
  final String apiHost;

  QuoteService(BrowserClient super.http, Config config) : apiHost = config.apiHost;

  Future<QuotesPage> listBookQuotes(String authorId, String bookId, PageRequest request) {
    var urlParams = pageRequestToUrlParams(request);
    var url = "$apiHost/authors/$authorId/books/$bookId/quotes?$urlParams";
    return getEntity(url).then((json) => QuotesPage.fromJson(json));
  }

  Future<QuotesPage> listQuotes(String searchPhrase, PageRequest request) {
    var url = "$apiHost/quotes?${pageRequestToUrlParams(request)}";
    url = appendUrlParam(url, paramSearchPhrase, searchPhrase);
    return getEntity(url).then((json) => QuotesPage.fromJson(json));
  }

  Future<QuoteEventsPage> listEvents(String authorId, String bookId, String quoteId, PageRequest request) {
    var urlParams = pageRequestToUrlParams(request);
    var url = "$apiHost/authors/$authorId/books/$bookId/quotes/$quoteId/events?$urlParams";
    return getEntity(url).then((json) => QuoteEventsPage.fromJson(json));
  }

  Future<Quote> find(String authorId, String bookId, String quoteId) {
    var url = "$apiHost/authors/$authorId/books/$bookId/quotes/$quoteId";
    return getEntity(url).then((json) => Quote.fromJson(json));
  }

  Future<Quote> update(Quote quote) {
    var url = "$apiHost/authors/${quote.authorId}/books/${quote.bookId}/quotes/${quote.id}";
    return updateEntity(url, quote).then((json) => Quote.fromJson(json));
  }

  Future<Quote> create(Quote quote) {
    var url = "$apiHost/authors/${quote.authorId}/books/${quote.bookId}/quotes";
    return createEntity(url, quote).then((json) => Quote.fromJson(json));
  }

  Future<String> delete(String authorId, String bookId, String quoteId) {
    var url = "$apiHost/authors/$authorId/books/$bookId/quotes/$quoteId";
    return deleteEntity(url).then((_) => quoteId);
  }
}
