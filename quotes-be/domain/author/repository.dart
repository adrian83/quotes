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

  Future<Page<Author>> list(PageRequest request) async {
    var req = new SearchRequest.all()
      ..size = request.limit
      ..from = request.offset;

    var resp = await _store.list(req);

    var athrs = resp.hits.hits.map((d) => Author.fromJson(d.source)).toList();
    var info = new PageInfo(request.limit, request.offset, resp.hits.total);
    return new Page<Author>(info, athrs);
  }

  Future<Author> find(String authorId) async =>
      _store.get(authorId).then((gr) => Author.fromJson(gr.source));

  Future<Author> update(Author author) =>
      _store.update(author).then((_) => author);

  Future<void> delete(String authorId) => _store.delete(authorId);
}
