import 'dart:async';

import 'package:uuid/uuid.dart';

import '../../infrastructure/elasticsearch/document.dart';
import '../../infrastructure/elasticsearch/search.dart';
import '../../infrastructure/elasticsearch/store.dart';
import '../common/event.dart';
import '../common/model.dart';
import 'model.dart';

DocumentDecoder<BookEvent> bookEventDecoder = (Map<String, dynamic> json) => BookEvent.fromJson(json);

DocumentDecoder<Book> authorDecoder = (Map<String, dynamic> json) => Book.fromJson(json);

DocumentCreator<BookEvent, Book> bookEventCreator = (Book book) => BookEvent.created(Uuid().v4(), book);

DocumentModifier<BookEvent, Book> bookEventModifier = (Book book) => BookEvent.modified(Uuid().v4(), book);

DocumentDeleter<BookEvent, Book> bookEventDeleter = (Book book) => BookEvent.deleted(Uuid().v4(), book);

class BookEventRepository extends EventRepository<BookEvent, Book> {
  BookEventRepository(ESStore<BookEvent> store) : super(store, bookEventDecoder, authorDecoder, bookEventCreator, bookEventModifier, bookEventDeleter);

  Future<void> deleteByAuthor(String authorId) {
    var authorIdQ = MatchQuery("authorId", authorId);
    var operationQ = MatchQuery("operation", ESDocument.created);
    var query = BoolQuery.must(MustQuery([authorIdQ, operationQ]));
    return super.deleteByQuery(query);
  }

  Future<Page<BookEvent>> listEvents(String authorId, String bookId, PageRequest request) {
    var query = MatchQuery("id", bookId);
    return super.listEventsByQuery(query, request);
  }
}
