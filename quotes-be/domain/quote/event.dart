import 'dart:async';

import 'package:uuid/uuid.dart';

import '../../tools/elasticsearch/document.dart';
import '../../tools/elasticsearch/search.dart';
import '../../tools/elasticsearch/store.dart';
import '../common/event.dart';
import '../common/model.dart';
import 'model.dart';

DocumentDecoder<QuoteEvent> quoteEventDecoder =
    (Map<String, dynamic> json) => QuoteEvent.fromJson(json);
DocumentDecoder<Quote> quoteDecoder =
    (Map<String, dynamic> json) => Quote.fromJson(json);

class QuoteEventRepository extends EventRepository<QuoteEvent, Quote> {
  QuoteEventRepository(ESStore<QuoteEvent> store)
      : super(store, quoteEventDecoder, quoteDecoder);

  Future<Quote> save(Quote quote) => Future.value(Uuid().v4())
      .then((docId) => QuoteEvent.created(docId, quote))
      .then((event) => store.index(event))
      .then((_) => quote);

  Future<Quote> update(Quote quote) => Future.value(Uuid().v4())
      .then((docId) => QuoteEvent.modified(docId, quote))
      .then((event) => store.index(event))
      .then((_) => quote);

  Future<void> delete(String quoteId) => findNewest(quoteId)
      .then((quote) => QuoteEvent.deleted(Uuid().v4(), quote))
      .then((event) => store.index(event));

  Future<void> deleteByAuthor(String authorId) {
    var authorIdQ = MatchQuery("authorId", authorId);
    var operationQ = MatchQuery("operation", ESDocument.created);
    var query = BoolQuery.must(MustQuery([authorIdQ, operationQ]));
    return super.deleteByQuery(query);
  }

  Future<void> deleteByBook(String bookId) {
    var bookIdQ = MatchQuery("bookId", bookId);
    var operationQ = MatchQuery("operation", ESDocument.created);
    var query = BoolQuery.must(MustQuery([bookIdQ, operationQ]));
    return super.deleteByQuery(query);
  }

  Future<Page<QuoteEvent>> listEvents(
      String authorId, String bookId, String quoteId, PageRequest request) {
    var query = MatchQuery("id", quoteId);
    return super.listEventsByQuery(query, request);
  }
}
