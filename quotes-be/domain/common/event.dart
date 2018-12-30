import 'dart:async';

import '../../tools/elasticsearch/document.dart';
import '../../tools/elasticsearch/response.dart';
import '../../tools/elasticsearch/search.dart';
import '../../tools/elasticsearch/store.dart';
import 'model.dart';

typedef DocumentDecoder<T> = T Function(Map<String, dynamic> doc);

abstract class EventRepository<EVENT extends ESDocument,
    ENTITY extends Entity> {
  ESStore<EVENT> _store;
  DocumentDecoder<EVENT> _eventDecoder;
  DocumentDecoder<ENTITY> _entityDecoder;

  EventRepository(this._store, this._eventDecoder, this._entityDecoder);

  ESStore<EVENT> get store => _store;

  Future<ENTITY> find(String entityId) =>
      _store.get(entityId).then((gr) => _entityDecoder(gr.source));

  Future<ENTITY> findNewest(String entityId) {
    var query = MatchQuery("id", entityId);

    var request = SearchRequest.oneByQuery(query)
      ..sort = [SortElement.desc("modifiedUtc")];

    return _store
        .list(request)
        .then((resp) => resp.hits)
        .then((hits) => _entityDecoder(hits.hits[0].source));
  }

  Future<Page<EVENT>> listEventsByQuery(Query query, PageRequest request) {
    var req = SearchRequest()
      ..query = query
      ..size = request.limit
      ..from = request.offset
      ..sort = [SortElement.asc("modifiedUtc")];

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

  Future<void> delete(String entity);

  List<EVENT> _fromDocuments(List<SearchHit> hits) =>
      hits.map((h) => _eventDecoder(h.source)).toList();
}
