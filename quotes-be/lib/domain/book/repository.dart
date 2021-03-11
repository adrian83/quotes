import 'dart:async';

import '../common/model.dart';
import '../common/repository.dart';
import 'model.dart';

import '../../infrastructure/elasticsearch/search.dart';
import '../../infrastructure/elasticsearch/store.dart';

Decoder<Book> bookDecoder = (Map<String, dynamic> json) => Book.fromJson(json);

class BookRepository extends Repository<Book> {
  BookRepository(ESStore<Book> store) : super(store, bookDecoder);

  Future<Page<Book>> findAuthorBooks(ListBooksByAuthorRequest request) {
    var query = MatchQuery("authorId", request.authorId); // TODO: better query

    return this.findDocuments(query, request.pageRequest);
  }

  Future<Page<Book>> findBooks(SearchEntityRequest request) {
    var phrase = request.searchPhrase ?? "";
    var query = WildcardQuery("title", phrase); // TODO: better query

    return this.findDocuments(query, request.pageRequest);
  }

  Future<void> deleteByAuthor(String authorId) {
    var query = MatchQuery("authorId", authorId); // TODO: better query
    return this.deleteDocuments(query);
  }
}

Decoder<BookEvent> bookEventDecoder = (Map<String, dynamic> json) => BookEvent.fromJson(json);

class BookEventRepository extends Repository<BookEvent> {
  BookEventRepository(ESStore<BookEvent> store) : super(store, bookEventDecoder);

  Future<void> deleteByAuthor(String authorId) {
    var authorIdQ = MatchQuery("entity.authorId", authorId);
    return super.deleteDocuments(authorIdQ);
  }

  Future<Page<BookEvent>> listEvents(ListEventsByBookRequest request) {
    var query = MatchQuery("entity.id", request.bookId);
    return super.findDocuments(query, request.pageRequest);
  }
}
