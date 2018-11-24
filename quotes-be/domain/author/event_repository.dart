import 'dart:async';

import 'package:uuid/uuid.dart';

import 'model.dart';

import '../common/model.dart';
import '../../store/elasticsearch_store.dart';
import '../../store/search.dart';

class AuthorEventRepository {
  ESStore<AuthorEvent> _store;

  AuthorEventRepository(this._store);

  Future<Author> save(Author author) => Future.value(Uuid().v4())
      .then((eventId) => AuthorEvent.created(eventId, author))
      .then((event) => _store.index(event))
      .then((_) => author);

  Future<Page<AuthorEvent>> listEvents(String authorId, PageRequest request) {
    var query = MatchQuery("id", authorId);

    var req = SearchRequest()
      ..query = query
      ..size = request.limit
      ..from = request.offset;
     // ..sort = [SortElement.asc("created")];

    return _store.list(req).then((resp) => resp.hits).then((hits) {
      var authors = hits.hits.map((d) => AuthorEvent.fromJson(d.source)).toList();
      var info = PageInfo(request.limit, request.offset, hits.total);
      return Page<AuthorEvent>(info, authors);
    });
  }

  Future<Author> find(String authorId) =>
      _store.get(authorId).then((gr) => Author.fromJson(gr.source));

  Future<Author> update(Author author) => Future.value(Uuid().v4())
      .then((eventId) => AuthorEvent.modified(eventId, author))
      .then((event) => _store.index(event))
      .then((_) => author);
  //return _store.update(authorEvent).then((_) => author);

  Future<void> delete(Author author) => Future.value(Uuid().v4())
      .then((eventId) => AuthorEvent.deleted(eventId, author))
      .then((event) => _store.index(event))
      .then((_) => author);
  //return _store.delete(authorEvent.docId);}

}
