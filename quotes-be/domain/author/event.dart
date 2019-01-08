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

DocumentCreator<AuthorEvent, Author> authorEventCreator =
    (Author author) => AuthorEvent.created(Uuid().v4(), author);

DocumentModifier<AuthorEvent, Author> authorEventModifier =
    (Author author) => AuthorEvent.modified(Uuid().v4(), author);

DocumentDeleter<AuthorEvent, Author> authorEventDeleter =
    (Author author) => AuthorEvent.deleted(Uuid().v4(), author);

class AuthorEventRepository extends EventRepository<AuthorEvent, Author> {
  AuthorEventRepository(ESStore<AuthorEvent> store)
      : super(store, authorEventDecoder, authorDecoder, authorEventCreator,
            authorEventModifier, authorEventDeleter);

  Future<Page<AuthorEvent>> listEvents(String authorId, PageRequest request) {
    var query = MatchQuery("id", authorId);
    return super.listEventsByQuery(query, request);
  }
}
