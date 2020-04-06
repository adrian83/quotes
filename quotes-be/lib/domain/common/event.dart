import 'dart:async';

import '../../infrastructure/elasticsearch/document.dart';
import '../../infrastructure/elasticsearch/response.dart';
import '../../infrastructure/elasticsearch/search.dart';
import '../../infrastructure/elasticsearch/store.dart';
import 'model.dart';

typedef DocumentDecoder<T> = T Function(Map<String, dynamic> doc);
typedef DocumentCreator<T, S> = T Function(S entity);
typedef DocumentModifier<T, S> = T Function(S entity);
typedef DocumentDeleter<T, S extends Entity> = T Function(S entity);

abstract class EventRepository<EVENT extends ESDocument, ENTITY extends Entity> {
  ESStore<EVENT> _store;
  DocumentDecoder<EVENT> _eventDecoder;
  DocumentDecoder<ENTITY> _entityDecoder;
  DocumentCreator<EVENT, ENTITY> _documentCreator;
  DocumentModifier<EVENT, ENTITY> _documentModifier;
  DocumentDeleter<EVENT, ENTITY> _documentDeleter;

  EventRepository(this._store, this._eventDecoder, this._entityDecoder, this._documentCreator, this._documentModifier, this._documentDeleter);

  ESStore<EVENT> get store => _store;

  Future<ENTITY> save(ENTITY entity) => Future.value(_documentCreator(entity)).then((event) => store.index(event)).then((_) => entity);

  Future<ENTITY> update(ENTITY entity) => Future.value(_documentModifier(entity)).then((event) => store.index(event)).then((_) => entity);

  Future<ENTITY> find(String entityId) => _store.get(entityId).then((gr) => _entityDecoder(gr.source));

  Future<void> delete(String entityId) => findNewest(entityId)
      .then((entity) {
        entity.modifiedUtc = DateTime.now().toUtc();
        return entity;
      })
      .then((entity) => _documentDeleter(entity))
      .then((event) => store.index(event))
      .then((_) => entityId);

  Future<ENTITY> findNewest(String entityId) {
    var query = MatchQuery("id", entityId);
    var sort = SortElement.desc("modifiedUtc");
    var request = SearchRequest.oneByQuery(query, [sort]);

    return _store.list(request).then((resp) => resp.hits).then((hits) => hits.hits[0].source).then((hit) => _entityDecoder(hit));
  }

  Future<Page<EVENT>> listEventsByQuery(Query query, PageRequest request) {
    var sort = SortElement.asc("modifiedUtc");
    var req = SearchRequest(query, [sort], request.offset, request.limit);

    return store.list(req).then((resp) => resp.hits).then((hits) {
      var authors = _fromDocuments(hits.hits);
      var info = PageInfo(request.limit, request.offset, hits.total);
      return Page<EVENT>(info, authors);
    });
  }

  Future<void> deleteByQuery(Query query) => store
      .list(SearchRequest.allByQuery(query))
      .then((resp) => resp.hits)
      .then((hits) => hits.hits.map((d) => _entityDecoder(d.source)).toList())
      .then((events) => events.map((event) => delete(event.id)));

  List<EVENT> _fromDocuments(List<SearchHit> hits) => hits.map((h) => _eventDecoder(h.source)).toList();
}
