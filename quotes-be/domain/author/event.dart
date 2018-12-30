import 'dart:async';

import 'package:uuid/uuid.dart';

import '../../tools/elasticsearch/search.dart';
import '../../tools/elasticsearch/store.dart';
import '../common/event.dart';
import '../common/model.dart';
import 'model.dart';

DocumentDecoder<AuthorEvent> authorEventDecoder =
    (Map<String, dynamic> json) => AuthorEvent.fromJson(json);
DocumentDecoder<Author> authorDecoder =
    (Map<String, dynamic> json) => Author.fromJson(json);

class AuthorEventRepository extends EventRepository<AuthorEvent, Author> {
  AuthorEventRepository(ESStore<AuthorEvent> store)
      : super(store, authorEventDecoder, authorDecoder);

  Future<Author> save(Author author) => Future.value(Uuid().v4())
      .then((eventId) => AuthorEvent.created(eventId, author))
      .then((event) => store.index(event))
      .then((_) => author);

  Future<Author> update(Author author) => Future.value(Uuid().v4())
      .then((eventId) => AuthorEvent.modified(eventId, author))
      .then((event) => store.index(event))
      .then((_) => author);

  Future<void> delete(String authorId) => findNewest(authorId)
      .then((author) {
        author.modifiedUtc = DateTime.now().toUtc();
        return author;
      })
      .then((author) => AuthorEvent.deleted(Uuid().v4(), author))
      .then((event) => store.index(event))
      .then((_) => authorId);

  Future<Page<AuthorEvent>> listEvents(String authorId, PageRequest request) {
    var query = MatchQuery("id", authorId);
    return super.listEventsByQuery(query, request);
  }
}
