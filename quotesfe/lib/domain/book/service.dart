import 'dart:async';

import 'package:http/browser_client.dart';
import 'package:quotesfe/domain/book/event.dart';
import 'package:quotesfe/domain/book/model.dart';
import 'package:quotesfe/domain/common/page.dart';
import 'package:quotesfe/domain/common/service.dart';
import 'package:quotesfe/tools/config.dart';

class BookService extends Service<Book> {
  final String _apiHost;

  BookService(BrowserClient http, Config config)
      : _apiHost = config.apiHost,
        super(http);

  Future<BooksPage> listAuthorBooks(String authorId, PageRequest request) {
    var urlParams = pageRequestToUrlParams(request);
    var url = "$_apiHost/authors/$authorId/books?$urlParams";
    return getEntity(url).then((json) => BooksPage.fromJson(json));
  }

  Future<BooksPage> listBooks(String searchPhrase, PageRequest request) {
    var url = "$_apiHost/books?${pageRequestToUrlParams(request)}";
    url = appendUrlParam(url, paramSearchPhrase, searchPhrase);
    return getEntity(url).then((json) => BooksPage.fromJson(json));
  }

  Future<BookEventsPage> listEvents(
      String authorId, String bookId, PageRequest request) {
    var urlParams = pageRequestToUrlParams(request);
    var url = "$_apiHost/authors/$authorId/books/$bookId/events?$urlParams";
    return getEntity(url).then((json) => BookEventsPage.fromJson(json));
  }

  Future<Book> find(String authorId, String bookId) {
    var url = "$_apiHost/authors/$authorId/books/$bookId";
    return getEntity(url).then((json) => Book.fromJson(json));
  }

  Future<Book> update(Book book) {
    var url = "$_apiHost/authors/${book.authorId}/books/${book.id}";
    return updateEntity(url, book).then((json) => Book.fromJson(json));
  }

  Future<Book> create(Book book) {
    var url = "$_apiHost/authors/${book.authorId}/books";
    return createEntity(url, book).then((json) => Book.fromJson(json));
  }

  Future<String> delete(String authorId, String bookId) {
    var url = "$_apiHost/authors/$authorId/books/$bookId";
    return deleteEntity(url).then((_) => bookId);
  }
}
