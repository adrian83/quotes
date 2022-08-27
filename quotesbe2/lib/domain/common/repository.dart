import 'dart:async';

import 'package:quotesbe2/common/function.dart';
import 'package:quotesbe2/domain/common/model.dart';
import 'package:quotesbe2/storage/elasticsearch/document.dart';
import 'package:quotesbe2/storage/elasticsearch/store.dart';
import 'package:quotesbe2/storage/elasticsearch/search.dart';


typedef Decoder<T> = T Function(Map<String, dynamic> json);

class Repository<T extends Document> {
  final ESStore<T> _store;
  final Decoder<T> _fromJson;

  Repository(this._store, this._fromJson);

  Future<void> save(T doc) => _store.index(doc).then((ir) => doc);

  Future<T> find(String docId) => _store.get(docId).then((gr) => _fromJson(gr.source));

  Future<T> update(T doc) => _store.update(doc).then((ir) => doc);

  Future<void> delete(String docId) => _store.delete(docId);

  Future<void> deleteDocuments(Query query) => _store.deleteByQuery(query);

  Future<Page<T>> findDocuments(Query query, PageRequest pageRequest, {SortElement? sorting}) =>
      Future.value(sorting ?? SortElement.asc("_id"))
          .then((sorting) => SearchRequest(query, [sorting], pageRequest.offset, pageRequest.limit))
          .then((request) => _store.list(request))
          .then((resp) => resp.hits)
          .then((hits) {
        var docs = hits.hits.map((h) => _fromJson(h.source)).toList();
        var info = PageInfo(pageRequest.limit, pageRequest.offset, hits.total.value);
        return Page<T>(info, docs);
      });

  List<N> newestEntities<N extends Entity, K>(Page<Event<N>> page) => groupBy(page.elements, (event) => (event as Event).entity.id)
        .map((key, value) {
          value.sort((a, b) => a.entity.createdUtc.compareTo(b.entity.createdUtc));
          return MapEntry(key, value[0].entity);
        })
        .values
        .toList();
}
