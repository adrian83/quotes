import 'dart:async';

import 'package:uuid/uuid.dart';

import '../../internal/elasticsearch/document.dart';
import '../../internal/elasticsearch/search.dart';
import '../../internal/elasticsearch/store.dart';
import '../common/event.dart';
import '../common/model.dart';
import 'model.dart';

DocumentDecoder<QuoteEvent> quoteEventDecoder =
    (Map<String, dynamic> json) => QuoteEvent.fromJson(json);

DocumentDecoder<Quote> quoteDecoder =
    (Map<String, dynamic> json) => Quote.fromJson(json);

DocumentCreator<QuoteEvent, Quote> quoteEventCreator =
    (Quote quote) => QuoteEvent.created(Uuid().v4(), quote);

DocumentModifier<QuoteEvent, Quote> quoteEventModifier =
    (Quote quote) => QuoteEvent.modified(Uuid().v4(), quote);

DocumentDeleter<QuoteEvent, Quote> quoteEventDeleter =
    (Quote quote) => QuoteEvent.deleted(Uuid().v4(), quote);

class QuoteEventRepository extends EventRepository<QuoteEvent, Quote> {
  QuoteEventRepository(ESStore<QuoteEvent> store)
      : super(store, quoteEventDecoder, quoteDecoder, quoteEventCreator,
            quoteEventModifier, quoteEventDeleter);

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
