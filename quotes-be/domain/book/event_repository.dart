import 'dart:async';

import 'package:uuid/uuid.dart';

import 'model.dart';

import '../common/model.dart';
import '../../store/elasticsearch_store.dart';
import '../../store/search.dart';

class BookEventRepository {
  ESStore<BookEvent> _store;

  BookEventRepository(this._store);

  List<Book> books = [];

  Future<Book> save(Book book) {
    var docId = Uuid().v4();
    var bookEvent = BookEvent.created(docId, book);
    return _store.index(bookEvent).then((_) => book);
  }

  Future<Page<Book>> findBooks(String authorId, PageRequest request) {
    var query = MatchQuery("authorId", authorId);

    var req = SearchRequest()
      ..query = query
      ..size = request.limit
      ..from = request.offset
      ..sort = [SortElement.asc("created")];

    return _store.list(req).then((resp) => resp.hits).then((hits) {
      var books = hits.hits.map((d) => Book.fromJson(d.source)).toList();
      var info = PageInfo(request.limit, request.offset, hits.total);
      return Page<Book>(info, books);
    });
  }

  Future<Book> find(String bookId) =>
      _store.get(bookId).then((gr) => Book.fromJson(gr.source));

  Future<Book> update(Book book) {
    var docId = Uuid().v4();
    var bookEvent = BookEvent.modified(docId, book);
    return _store.index(bookEvent).then((_) => book);
    //_store.update(book).then((_) => book);
  }

  Future<void> delete(Book book) {
    var docId = Uuid().v4();
    var bookEvent = BookEvent.deleted(docId, book);
    return _store.index(bookEvent).then((_) => book);
    // _store.delete(bookId);
  }

  Future<void> deleteByAuthor(String authorId) {
    var query = JustQuery(MatchQuery("authorId", authorId));
    return _store.deleteByQuery(query);
  }
}
