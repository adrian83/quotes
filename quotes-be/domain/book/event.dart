import 'dart:async';

import 'package:uuid/uuid.dart';

import '../../tools/elasticsearch/document.dart';
import '../../tools/elasticsearch/search.dart';
import '../../tools/elasticsearch/store.dart';
import '../common/event.dart';
import '../common/model.dart';
import 'model.dart';

DocumentDecoder<BookEvent> bookEventDecoder =
    (Map<String, dynamic> json) => BookEvent.fromJson(json);
DocumentDecoder<Book> authorDecoder =
    (Map<String, dynamic> json) => Book.fromJson(json);

class BookEventRepository extends EventRepository<BookEvent, Book> {
  BookEventRepository(ESStore<BookEvent> store)
      : super(store, bookEventDecoder, authorDecoder);

  Future<Book> save(Book book) => Future.value(Uuid().v4())
      .then((eventId) => BookEvent.created(eventId, book))
      .then((event) => store.index(event))
      .then((_) => book);

  Future<Page<Book>> findBooks(String authorId, PageRequest request) =>
      Future.value(MatchQuery("authorId", authorId))
          .then((query) => SearchRequest()
            ..query = query
            ..size = request.limit
            ..from = request.offset
            ..sort = [SortElement.asc("createdUtc")])
          .then((req) => store.list(req))
          .then((resp) => resp.hits)
          .then((hits) {
        var books = hits.hits.map((d) => Book.fromJson(d.source)).toList();
        var info = PageInfo(request.limit, request.offset, hits.total);
        return Page<Book>(info, books);
      });

  Future<Book> update(Book book) => Future.value(Uuid().v4())
      .then((eventId) => BookEvent.modified(eventId, book))
      .then((event) => store.index(event))
      .then((_) => book);

  Future<void> delete(String bookId) => findNewest(bookId)
      .then((book) => BookEvent.deleted(Uuid().v4(), book))
      .then((event) => store.index(event))
      .then((_) => print("bookevent with id $bookId removed"));

  Future<void> deleteByAuthor(String authorId) {
    var authorIdQ = MatchQuery("authorId", authorId);
    var operationQ = MatchQuery("operation", ESDocument.created);
    var query = BoolQuery.must(MustQuery([authorIdQ, operationQ]));
    return super.deleteByQuery(query);
  }

  Future<Page<BookEvent>> listEvents(
      String authorId, String bookId, PageRequest request) {
    var query = MatchQuery("id", bookId);
    return super.listEventsByQuery(query, request);
  }
}
