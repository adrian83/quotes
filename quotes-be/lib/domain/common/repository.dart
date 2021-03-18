import 'dart:async';

import 'model.dart';
import '../common/model.dart';
import '../../common/function.dart';
import '../../infrastructure/elasticsearch/search.dart';
import '../../infrastructure/elasticsearch/store.dart';
import '../../infrastructure/elasticsearch/document.dart';

typedef Decoder<T> = T Function(Map<String, dynamic> json);

class Repository<T extends Document> {
  ESStore<T> _store;
  Decoder<T> _fromJson;

  Repository(this._store, this._fromJson);

  Future<void> save(T doc) => _store.index(doc).then((ir) => doc);

  Future<T> find(String docId) => _store.get(docId).then((gr) => _fromJson(gr.source));
  
  Future<T> update(T doc) => _store.update(doc).then((ir) => doc);
  
  Future<void> delete(String docId) => _store.delete(docId);
  

  Future<void> deleteDocuments(Query query) => _store.deleteByQuery(query);


  Future<Page<T>> findDocuments(Query query, PageRequest pageRequest, {SortElement? sorting}) =>
      Future.value(sorting == null ? SortElement.asc("_id") : sorting)
          .then((sorting) => SearchRequest(query, [sorting], pageRequest.offset, pageRequest.limit))
          .then((request) => _store.list(request))
          .then((resp) => resp.hits)
          .then((hits) {
        var docs = hits.hits.map((h) => _fromJson(h.source)).toList();
        var info = PageInfo(pageRequest.limit, pageRequest.offset, hits.total);
        return Page<T>(info, docs);
      });

  List<N> newestEntities<N extends Entity, T>(Page<Event<N>> page) {
    return groupBy(page.elements, (event) => (event as Event).entity.id)
        .map((key, value) {
          value.sort((a, b) => a.entity.createdUtc.compareTo(b.entity.createdUtc));
          return MapEntry(key, value[0].entity);
        })
        .values
        .toList();
  }
}
