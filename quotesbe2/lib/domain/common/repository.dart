import 'dart:async';

import 'package:quotesbe2/common/function.dart';
import 'package:quotesbe2/domain/common/model.dart';
import 'package:quotesbe2/storage/elasticsearch/document.dart';
import 'package:quotesbe2/storage/elasticsearch/store.dart';
import 'package:quotesbe2/storage/elasticsearch/search.dart';

var sortingByModifiedTimeDesc = SortElement.desc(modifiedUtcLabel);
var sortingByCreatedTimeAsc = SortElement.asc(createdUtcLabel);

typedef Decoder<T> = T Function(Map<String, dynamic> json);

const maxPageSize = 1000;

class Repository<T extends Document> {
  final ESStore<T> _store;
  final Decoder<T> _fromJson;

  Repository(this._store, this._fromJson);

  Future<void> save(T doc) => _store.index(doc).then((ir) => doc);

  Future<T> find(String docId) =>
      _store.get(docId).then((gr) => _fromJson(gr.source));

  Future<T> update(T doc) => _store.update(doc).then((ir) => doc);

  Future<void> delete(String docId) => _store.delete(docId);

  Future<void> deleteDocuments(Query query) => _store.deleteByQuery(query);

  Future<Page<T>> findDocuments(
    Query query,
    PageRequest pageRequest, {
    SortElement? sorting,
  }) async {
    var sort = sorting ?? SortElement.asc("_id");
    var searchRequest =
        SearchRequest(query, [sort], pageRequest.offset, pageRequest.limit);
    var result = await _store.list(searchRequest);
    var hits = result.hits;
    var docs = hits.hits.map((h) => _fromJson(h.source)).toList();
    var info =
        PageInfo(pageRequest.limit, pageRequest.offset, hits.total.value);
    return Page<T>(info, docs);
  }

  Future<List<T>> findAllDocuments(Query query,
      {PageRequest? pageRequest,}) async {
    var sorting = SortElement.asc("_id");
    var pageReq = pageRequest ?? PageRequest(maxPageSize, 0);
    var searchQuery =
        SearchRequest(query, [sorting], pageReq.offset, pageReq.limit);
    var resp = await _store.list(searchQuery);
    var docs = resp.hits.hits.map((h) => _fromJson(h.source)).toList();
    if (docs.length == maxPageSize) {
      var newPageReq =
          PageRequest(pageReq.limit, pageReq.offset + pageReq.limit);
      var other = await findAllDocuments(query, pageRequest: newPageReq);
      return [...docs, ...other];
    }
    return docs;
  }

  String _extractEntityIdFromEvent(Event e) => e.entity.id;

  int _compareEventsEntityCreationTimes(Event a, Event b) =>
      a.entity.createdUtc.compareTo(b.entity.createdUtc);

  List<N> newestEntities<N extends Entity, K>(List<Event<N>> elements) =>
      groupBy(elements, _extractEntityIdFromEvent)
          .map((key, value) {
            value.sort(_compareEventsEntityCreationTimes);
            return MapEntry(key, value.first.entity);
          })
          .values
          .toList();
}
