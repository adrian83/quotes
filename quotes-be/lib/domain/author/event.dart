import 'dart:async';

import 'package:uuid/uuid.dart';

import '../../internal/elasticsearch/search.dart';
import '../../internal/elasticsearch/store.dart';
import '../common/event.dart';
import '../common/model.dart';
import 'model.dart';

DocumentDecoder<AuthorEvent> eventDecoder = (Map<String, dynamic> json) => AuthorEvent.fromJson(json);
DocumentDecoder<Author> decoder = (Map<String, dynamic> json) => Author.fromJson(json);
DocumentCreator<AuthorEvent, Author> eventCreator = (Author author) => AuthorEvent.created(Uuid().v4(), author);
DocumentModifier<AuthorEvent, Author> eventModifier = (Author author) => AuthorEvent.modified(Uuid().v4(), author);
DocumentDeleter<AuthorEvent, Author> eventDeleter = (Author author) => AuthorEvent.deleted(Uuid().v4(), author);

class AuthorEventRepository extends EventRepository<AuthorEvent, Author> {
  AuthorEventRepository(ESStore<AuthorEvent> store)
      : super(store, eventDecoder, decoder, eventCreator, eventModifier, eventDeleter);

  Future<Page<AuthorEvent>> listEvents(String authorId, PageRequest request) {
    var query = MatchQuery("id", authorId);
    return super.listEventsByQuery(query, request);
  }
}
