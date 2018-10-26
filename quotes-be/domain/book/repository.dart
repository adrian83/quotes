import 'dart:async';

import 'package:uuid/uuid.dart';

import 'model.dart';

import '../common/model.dart';
import '../../store/elasticsearch_store.dart';
import '../../store/search.dart';

class BookRepository {
  ESStore<Book> _store;

  BookRepository(this._store);

  List<Book> books = new List<Book>();

  Future<Book> save(Book book) {
    book.id = new Uuid().v4();
    return _store.index(book).then((_) => book);
  }

  Future<Page<Book>> findBooks(String authorId, PageRequest request) {
    var query = MatchQuery("authorId", authorId);

    var req = new SearchRequest()
      ..query = query
      ..size = request.limit
      ..from = request.offset;

    return _store.list(req).then((resp) => resp.hits).then((hits) {
      var books = hits.hits.map((d) => Book.fromJson(d.source)).toList();
      var info = new PageInfo(request.limit, request.offset, hits.total);
      return Page<Book>(info, books);
    });
  }

  Future<Book> find(String bookId) =>
      _store.get(bookId).then((gr) => Book.fromJson(gr.source));

  Future<Book> update(Book book) => _store.update(book).then((_) => book);

  Future<void> delete(String bookId) => _store.delete(bookId);
}
