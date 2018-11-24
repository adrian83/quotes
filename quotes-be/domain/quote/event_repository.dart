import 'dart:async';

import 'package:uuid/uuid.dart';

import 'model.dart';

import '../common/model.dart';
import '../../store/elasticsearch_store.dart';
import '../../store/search.dart';

class QuoteEventRepository {
  ESStore<QuoteEvent> _store;

  QuoteEventRepository(this._store);

  Future<Quote> save(Quote quote) => Future.value(Uuid().v4())
      .then((docId) => QuoteEvent.created(docId, quote))
      .then((event) => _store.index(event))
      .then((_) => quote);

  Future<Quote> update(Quote quote) => Future.value(Uuid().v4())
      .then((docId) => QuoteEvent.modified(docId, quote))
      .then((event) => _store.index(event))
      .then((_) => quote);

  Future<void> delete(Quote quote) => findNewest(quote.id)
      .then((quote) => QuoteEvent.deleted(Uuid().v4(), quote))
      .then((event) => _store.index(event))
      .then((_) => quote);

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

  Future<Quote> findNewest(String quoteId) {
    var query = MatchQuery("id", quoteId);

    var req = SearchRequest()
      ..query = query
      ..size = 1
      ..from = 0
      ..sort = [SortElement.asc("modifiedUtc")];

    return _store
        .list(req)
        .then((resp) => resp.hits)
        .then((hits) => hits.hits.map((d) => Quote.fromJson(d.source)).toList())
        .then((quotes) => quotes[0]);
  }

  Future<Quote> get(String id) =>
      _store.get(id).then((gr) => Quote.fromJson(gr.source));

  Future<void> deleteByAuthor(String authorId) {
    var query = JustQuery(MatchQuery("authorId", authorId));
    return _store.deleteByQuery(query);
  }
}
