import 'dart:async';

import 'package:uuid/uuid.dart';

import 'model.dart';

import '../common/model.dart';
import '../../tools/elasticsearch/store.dart';
import '../../tools/elasticsearch/search.dart';
import '../../tools/elasticsearch/document.dart';

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

  Future<void> delete(String quoteId) => findNewest(quoteId)
      .then((quote) => QuoteEvent.deleted(Uuid().v4(), quote))
      .then((event) => _store.index(event));

  Future<Page<Quote>> find(String bookId, PageRequest request) =>
      Future.value(MatchQuery("bookId", bookId))
          .then((query) => SearchRequest()
            ..query = query
            ..size = request.limit
            ..from = request.offset
            ..sort = [SortElement.asc("created")])
          .then((req) => _store.list(req))
          .then((resp) => resp.hits)
          .then((hits) {
        var quotes = hits.hits.map((d) => Quote.fromJson(d.source)).toList();
        var info = PageInfo(request.limit, request.offset, hits.total);
        return Page<Quote>(info, quotes);
      });

  Future<Quote> findNewest(String quoteId) =>
      Future.value(MatchQuery("id", quoteId))
          .then((query) => MatchQuery("id", quoteId))
          .then((query) => SearchRequest.oneByQuery(query)
            ..sort = [SortElement.asc("modifiedUtc")])
          .then((req) => _store.list(req))
          .then((resp) => resp.hits)
          .then(
              (hits) => hits.hits.map((d) => Quote.fromJson(d.source)).toList())
          .then((quotes) => quotes[0]);

  Future<Quote> get(String id) =>
      _store.get(id).then((gr) => Quote.fromJson(gr.source));

  Future<void> deleteByAuthor(String authorId) {
    var authorIdQ = MatchQuery("authorId", authorId);
    var operationQ = MatchQuery("operation", ESDocument.created);

    var query = BoolQuery.must(MustQuery([authorIdQ, operationQ]));

    var req = SearchRequest.allByQuery(query);

    return _store
        .list(req)
        .then((resp) {
          print("Removing quotes by author. Count: ${resp.hits.total}");
          return resp.hits;
        })
        .then((hits) => hits.hits.map((d) => Quote.fromJson(d.source)).toList())
        .then((quotes) => quotes.map((quote) => delete(quote.id)));
  }

  Future<void> deleteByBook(String bookId) {
    print("dasdsdasdasd");

    var bookIdQ = MatchQuery("bookId", bookId);
    var operationQ = MatchQuery("operation", ESDocument.created);

    var query = BoolQuery.must(MustQuery([bookIdQ, operationQ]));
    var req = SearchRequest.allByQuery(query);

    return _store
        .list(req)
        .then((resp) {
          print("Removing quotes by book. Count: ${resp.hits.total}");
          return resp.hits;
        })
        .then((hits) => hits.hits.map((d) => Quote.fromJson(d.source)).toList())
        .then((quotes) => quotes.map((quote) => delete(quote.id)));
  }
}
