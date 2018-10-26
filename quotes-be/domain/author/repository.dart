import 'dart:async';

import 'package:uuid/uuid.dart';

import 'model.dart';

import '../common/model.dart';
import '../../store/elasticsearch_store.dart';
import '../../store/search.dart';

class AuthorRepository {
  ESStore<Author> _store;

  AuthorRepository(this._store);

  Future<Author> save(Author author) {
    author.id = new Uuid().v4();
    return _store.index(author).then((_) => author);
  }

  Future<Page<Author>> list(PageRequest request) {
    var req = new SearchRequest.all()
      ..size = request.limit
      ..from = request.offset;

    return _store.list(req).then((resp) => resp.hits).then((hits) {
      var authors = hits.hits.map((d) => Author.fromJson(d.source)).toList();
      var info = new PageInfo(request.limit, request.offset, hits.total);
      return Page<Author>(info, authors);
    });
  }

  Future<Author> find(String authorId) =>
      _store.get(authorId).then((gr) => Author.fromJson(gr.source));

  Future<Author> update(Author author) =>
      _store.update(author).then((_) => author);

  Future<void> delete(String authorId) => _store.delete(authorId);
}
