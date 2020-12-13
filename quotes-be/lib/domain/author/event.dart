import 'dart:async';

import 'package:uuid/uuid.dart';

import '../../infrastructure/elasticsearch/search.dart';
import '../../infrastructure/elasticsearch/store.dart';
import '../common/event.dart';
import '../common/model.dart';
import 'model.dart';

DocumentDecoder<Author> authorDecoder = (Map<String, dynamic> json) => Author.fromJson(json);
DocumentDecoder<AuthorEvent> eventDecoder = (Map<String, dynamic> json) => AuthorEvent.fromJson(json);
DocumentCreator<AuthorEvent, Author> eventCreator = (Author author) => AuthorEvent.created(Uuid().v4(), author);
DocumentModifier<AuthorEvent, Author> eventModifier = (Author author) => AuthorEvent.modified(Uuid().v4(), author);
DocumentDeleter<AuthorEvent, Author> eventDeleter = (Author author) => AuthorEvent.deleted(Uuid().v4(), author);

class AuthorEventRepository extends EventRepository<AuthorEvent, Author> {
  AuthorEventRepository(ESStore<AuthorEvent> store) : super(store, eventDecoder, authorDecoder, eventCreator, eventModifier, eventDeleter);

  Future<Page<AuthorEvent>> listEvents(ListEventsByAuthorRequest request) {
    var query = MatchQuery("id", request.authorId);
    return super.listEventsByQuery(query, request.pageRequest);
  }
}
