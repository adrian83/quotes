import 'dart:async';

import 'package:http/browser_client.dart';

import 'model.dart';

import '../common/service.dart';
import '../common/page.dart';

class BookService extends Service<Book> {
  static final String _host = "http://localhost:5050";

  BookService(BrowserClient http) : super(http);

  Future<BooksPage> list(String authorId, PageRequest request) {
    var url =
        "$_host/authors/$authorId/books?${this.pageRequestToUrlParams(request)}";
    return getEntity(url).then((json) => BooksPage.fromJson(json));
  }

  Future<Book> get(String authorId, String bookId) {
    var url = "$_host/authors/$authorId/books/$bookId";
    return getEntity(url).then((json) => Book.fromJson(json));
  }

  Future<Book> update(Book book) {
    var url = "$_host/authors/${book.authorId}/books/${book.id}";
    return updateEntity(url, book).then((json) => Book.fromJson(json));
  }
}
