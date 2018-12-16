import 'dart:async';

import 'package:uuid/uuid.dart';

import 'model.dart';
import '../common/model.dart';
import '../../tools/elasticsearch/store.dart';
import '../../tools/elasticsearch/search.dart';
import '../../tools/elasticsearch/response.dart';
import '../../tools/elasticsearch/document.dart';

class BookEventRepository {
  ESStore<BookEvent> _store;

  BookEventRepository(this._store);

  Future<Book> save(Book book) => Future.value(Uuid().v4())
      .then((eventId) => BookEvent.created(eventId, book))
      .then((event) => _store.index(event))
      .then((_) => book);

  Future<Page<Book>> findBooks(String authorId, PageRequest request) =>
      Future.value(MatchQuery("authorId", authorId))
          .then((query) => SearchRequest()
            ..query = query
            ..size = request.limit
            ..from = request.offset
            ..sort = [SortElement.asc("createdUtc")])
          .then((req) => _store.list(req))
          .then((resp) => resp.hits)
          .then((hits) {
        var books = hits.hits.map((d) => Book.fromJson(d.source)).toList();
        var info = PageInfo(request.limit, request.offset, hits.total);
        return Page<Book>(info, books);
      });

  Future<Book> find(String bookId) =>
      _store.get(bookId).then((gr) => Book.fromJson(gr.source));

  Future<Book> update(Book book) => Future.value(Uuid().v4())
      .then((eventId) => BookEvent.modified(eventId, book))
      .then((event) => _store.index(event))
      .then((_) => book);

  Future<Book> findNewest(String bookId) =>
      Future.value(MatchQuery("id", bookId))
          .then((matchBookId) => SearchRequest.oneByQuery(matchBookId))
          .then((req) => _store.list(req))
          .then((resp) => resp.hits)
          .then((hits) => Book.fromJson(hits.hits[0].source));

  Future<void> delete(String bookId) => findNewest(bookId)
      .then((book) => BookEvent.deleted(Uuid().v4(), book))
      .then((event) => _store.index(event))
      .then((_) => print("bookevent with id $bookId removed"));

  Future<void> deleteByAuthor(String authorId) {
    var authorIdQ = MatchQuery("authorId", authorId);
    var operationQ = MatchQuery("operation", ESDocument.created);

    return Future.value(BoolQuery.must(MustQuery([authorIdQ, operationQ])))
        .then((query) => SearchRequest.allByQuery(query))
        .then((req) => _store.list(req))
        .then((resp) => resp.hits)
        .then((hits) => hits.hits.map((d) => Book.fromJson(d.source)).toList())
        .then((books) => books.map((book) => delete(book.id)));
  }

    Future<Page<BookEvent>> listEvents(String authorId, String bookId, PageRequest request) {
    var query = MatchQuery("id", bookId);

    var req = SearchRequest()
      ..query = query
      ..size = request.limit
      ..from = request.offset
      ..sort = [SortElement.asc("modifiedUtc")];

    return _store.list(req).then((resp) => resp.hits).then((hits) {
      var books = _fromDocuments(hits.hits);
      var info = PageInfo(request.limit, request.offset, hits.total);
      return Page<BookEvent>(info, books);
    });
  }

    List<BookEvent> _fromDocuments(List<SearchHit> hits) =>
      hits.map((h) => BookEvent.fromJson(h.source)).toList();
}
