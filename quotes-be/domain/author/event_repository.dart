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
      .then((docId) => AuthorEvent.created(docId, author))
      .then((event) => _store.index(event))
      .then((_) => author);

  Future<Page<Author>> list(PageRequest request) {
    var req = SearchRequest.all()
      ..size = request.limit
      ..from = request.offset
      ..sort = [SortElement.asc("created")];

    return _store.list(req).then((resp) => resp.hits).then((hits) {
      var authors = hits.hits.map((d) => Author.fromJson(d.source)).toList();
      var info = PageInfo(request.limit, request.offset, hits.total);
      return Page<Author>(info, authors);
    });
  }

  Future<Author> find(String authorId) =>
      _store.get(authorId).then((gr) => Author.fromJson(gr.source));

  Future<Author> update(Author author) => Future.value(Uuid().v4())
      .then((docId) => AuthorEvent.modified(docId, author))
      .then((event) => _store.index(event))
      .then((_) => author);
  //return _store.update(authorEvent).then((_) => author);

  Future<void> delete(Author author) => Future.value(Uuid().v4())
      .then((docId) => AuthorEvent.deleted(docId, author))
      .then((event) => _store.index(event))
      .then((_) => author);
  //return _store.delete(authorEvent.docId);}

}
