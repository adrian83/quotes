import 'dart:async';

import 'package:uuid/uuid.dart';
import 'model.dart';

import '../common/model.dart';

import '../../store/elasticsearch_store.dart';
import '../../store/search.dart';

class AuthorRepository {
  ESStore<Author> _store;

  AuthorRepository(this._store);

  Future<Author> save(Author author) async {
    author.id = new Uuid().v4();
    await _store.index(author);
    return author;
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

  Future<Author> find(String authorId) async => await _store.get(authorId).then((gr) => Author.fromJson(gr.source));

  Future<Author> update(Author author) async {
    await _store.update(author);
    return author;
  }

  Future<void> delete(String authorId) async => _store.delete(authorId);

}
