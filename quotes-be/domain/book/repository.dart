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

  Future<Book> save(Book book) async {
    book.id = new Uuid().v4();
    return _store.index(book).then((_) => book);
  }

  Future<Page<Book>> findBooks(String authorId, PageRequest request) async {
    var query = MatchQuery("authorId", authorId);

    var req = new SearchRequest()
      ..query = query
      ..size = request.limit
      ..from = request.offset;

    var resp = await _store.list(req);

    var books = resp.hits.hits.map((d) => Book.fromJson(d.source)).toList();
    var info = new PageInfo(request.limit, request.offset, resp.hits.total);
    return new Page<Book>(info, books);
  }

  Future<Book> find(String bookId) async =>
      _store.get(bookId).then((gr) => Book.fromJson(gr.source));

  Future<Book> update(Book book) => _store.update(book).then((_) => book);

  Future<void> delete(String bookId) => _store.delete(bookId);
}
