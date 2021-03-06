import 'dart:async';

import '../common/model.dart';
import '../common/repository.dart';
import 'model.dart';

import '../../infrastructure/elasticsearch/search.dart';
import '../../infrastructure/elasticsearch/store.dart';

Decoder<Quote> quoteDecoder = (Map<String, dynamic> json) => Quote.fromJson(json);

class QuoteRepository extends Repository<Quote> {
  QuoteRepository(ESStore<Quote> store) : super(store, quoteDecoder);

  Future<Page<Quote>> findBookQuotes(ListQuotesFromBookRequest request) {
    var query = MatchQuery("bookId", request.bookId); // TODO: better query

    return this.findDocuments(query, request.pageRequest);
  }

  Future<Page<Quote>> findQuotes(SearchEntityRequest request) {
    var phrase = request.searchPhrase ?? "";
    var query = WildcardQuery("text", phrase); // TODO: better query

    return this.findDocuments(query, request.pageRequest);
  }

  Future<void> deleteByAuthor(String authorId) {
    var query = MatchQuery("authorId", authorId); // TODO: better query
    return this.deleteDocuments(query);
  }
  // => deleteAll(deleteAuthorQuotesStmt, {"authorId": authorId});

  Future<void> deleteByBook(String bookId) {
    var query = MatchQuery("bookId", bookId); // TODO: better query
    return this.deleteDocuments(query);
  }
}
