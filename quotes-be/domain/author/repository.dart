import 'dart:async';

import 'package:uuid/uuid.dart';
import 'model.dart';

import '../common/model.dart';

import '../../store/elasticsearch_store.dart';

class AuthorRepository extends ESStore<Author> {
  List<Author> authors = new List<Author>();

  AuthorRepository(String host, int port, String index)
      : super(host, port, index);

  Future<Author> save(Author author) async {
    author.id = new Uuid().v4();
    await this.index(author);
    return author;
  }

  Future<Page<Author>> list(PageRequest request) async {
    var resp = await listDocuments(request.offset, request.limit);
    var athrs = resp.hits.hits.map((d) => Author.fromJson(d.source)).toList();
    var info = new PageInfo(request.limit, request.offset, resp.hits.total);
    return new Page<Author>(info, athrs);
  }

  Future<Author> find(String authorId) async =>
      await this.get(authorId).then((gr) => Author.fromJson(gr.source));

  Future<Author> update(Author author) async {
    await updateDocument(author);
    return author;
  }

  Future<void> delete(String authorId) async {
    await deleteDocument(authorId);
  }
}
