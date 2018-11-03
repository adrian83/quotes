import 'dart:async';

import 'package:uuid/uuid.dart';

import 'model.dart';

import '../common/model.dart';
import '../../store/elasticsearch_store.dart';
import '../../store/search.dart';

class QuoteRepository {
  ESStore<Quote> _store;

  QuoteRepository(this._store);

  Future<Quote> save(Quote quote) {
    quote.id = Uuid().v4();
    return _store.index(quote).then((_) => quote);
  }

  Future<Page<Quote>> find(String bookId, PageRequest request) {
    var query = MatchQuery("bookId", bookId);

    var req = SearchRequest()
      ..query = query
      ..size = request.limit
      ..from = request.offset
      ..sort = [SortElement.asc("created")];

    return _store.list(req).then((resp) => resp.hits).then((hits) {
      var quotes = hits.hits.map((d) => Quote.fromJson(d.source)).toList();
      var info = PageInfo(request.limit, request.offset, hits.total);
      return Page<Quote>(info, quotes);
    });
  }

  Future<Quote> get(String id) =>
      _store.get(id).then((gr) => Quote.fromJson(gr.source));

  Future<Quote> update(Quote quote) => _store.update(quote).then((_) => quote);

  Future<void> delete(String id) => _store.delete(id);

  Future<void> deleteByAuthor(String authorId) {
    var query = JustQuery(MatchQuery("authorId", authorId));
    return _store.deleteByQuery(query);
  }
}
