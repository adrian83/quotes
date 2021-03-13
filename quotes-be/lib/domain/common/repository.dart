import 'dart:async';
import 'dart:convert';

import 'package:logging/logging.dart';

import '../../infrastructure/elasticsearch/search.dart';
import '../../infrastructure/elasticsearch/store.dart';
import '../../infrastructure/elasticsearch/document.dart';
import '../common/model.dart';
import 'model.dart';

typedef Decoder<T> = T Function(Map<String, dynamic> json);

class Repository<T extends Document> {
  final Logger logger = Logger('Repository');

  ESStore<T> _store;
  Decoder<T> _fromJson;

  Repository(this._store, this._fromJson);

  Future<void> save(T doc) {
    logger.info("storing ${doc.toJson()}");
    return _store.index(doc).then((ir) => doc);
  }

  Future<T> find(String docId) {
    return _store.get(docId).then((gr) => _fromJson(gr.source));
  }

  Future<T> update(T doc) {
    return _store.index(doc).then((ir) => doc);
  }

  Future<void> delete(String docId) {
    return _store.delete(docId);
  }

  Future<String> mapping() => _store.mapping();

  Future<Page<T>> findDocuments(Query query, PageRequest pageRequest, {SortElement? sorting}) {
    var sort = sorting == null ? SortElement.asc("_id") : sorting;
    var req = SearchRequest(query, [sort], pageRequest.offset, pageRequest.limit);
    logger.info("finding documents ${jsonEncode(req)}");

    return _store.list(req).then((resp) => resp.hits).then((hits) {
      logger.info("found ${hits.total} documents");
      var docs = hits.hits.map((h) => _fromJson(h.source)).toList();
      logger.info("documents $docs");
      var info = PageInfo(pageRequest.limit, pageRequest.offset, hits.total);
      logger.info("info $info");
      return Page<T>(info, docs);
    });
  }

  Future<void> deleteDocuments(Query query) {
    return _store.deleteByQuery(query);
  }
}
