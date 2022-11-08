import 'dart:async';

import 'package:http/browser_client.dart';

import 'model.dart';
import 'event.dart';

import '../common/service.dart';
import '../common/page.dart';
import '../../tools/config.dart';

class BookService extends Service<Book> {
  final Config _config;

  BookService(BrowserClient http, this._config) : super(http);

  Future<BooksPage> listAuthorBooks(String authorId, PageRequest request) {
    var url =
        "${_config.beHost}/authors/$authorId/books?${pageRequestToUrlParams(request)}";
    return getEntity(url).then((json) => BooksPage.fromJson(json));
  }

  Future<BooksPage> listBooks(String searchPhrase, PageRequest request) {
    var url = "${_config.beHost}/books?${pageRequestToUrlParams(request)}";
    url = appendUrlParam(url, "searchPhrase", searchPhrase);
    return getEntity(url).then((json) => BooksPage.fromJson(json));
  }

  Future<BookEventsPage> listEvents(
      String authorId, String bookId, PageRequest request) {
    var url =
        "${_config.beHost}/authors/$authorId/books/$bookId/events?${pageRequestToUrlParams(request)}";
    return getEntity(url).then((json) => BookEventsPage.fromJson(json));
  }

  Future<Book> find(String authorId, String bookId) {
    var url = "${_config.beHost}/authors/$authorId/books/$bookId";
    return getEntity(url).then((json) => Book.fromJson(json));
  }

  Future<Book> update(Book book) {
    var url = "${_config.beHost}/authors/${book.authorId}/books/${book.id}";
    return updateEntity(url, book).then((json) => Book.fromJson(json));
  }

  Future<Book> create(Book book) {
    var url = "${_config.beHost}/authors/${book.authorId}/books";
    return createEntity(url, book).then((json) => Book.fromJson(json));
  }

  Future<String> delete(String authorId, String bookId) {
    var url = "${_config.beHost}/authors/$authorId/books/$bookId";
    return deleteEntity(url).then((_) => bookId);
  }
}
