import 'dart:async';

import 'package:logging/logging.dart';

import '../common/model.dart';
import '../common/repository.dart';
import 'model.dart';

import '../../common/function.dart';

import '../../infrastructure/elasticsearch/search.dart';
import '../../infrastructure/elasticsearch/store.dart';

Decoder<Book> bookDecoder = (Map<String, dynamic> json) => Book.fromJson(json);

class BookRepository extends Repository<Book> {
  BookRepository(ESStore<Book> store) : super(store, bookDecoder);

  Future<Page<Book>> findAuthorBooks(ListBooksByAuthorRequest request) {
    var query = MatchQuery(bookAuthorIdLabel, request.authorId); // TODO: better query
    return this.findDocuments(query, request.pageRequest);
  }

  Future<Page<Book>> findBooks(SearchEntityRequest request) {
    var phrase = request.searchPhrase ?? "";
    var query = WildcardQuery(bookTitleLabel, phrase); // TODO: better query
    return this.findDocuments(query, request.pageRequest);
  }

  Future<void> deleteByAuthor(String authorId) {
    var query = JustQuery(MatchQuery(bookAuthorIdLabel, authorId)); // TODO: better query
    return this.deleteDocuments(query);
  }
}

Decoder<BookEvent> bookEventDecoder = (Map<String, dynamic> json) => BookEvent.fromJson(json);

class BookEventRepository extends Repository<BookEvent> {
  final Logger logger = Logger('BookEventRepository');

  String _authorIdProp = "$entityLabel.$bookAuthorIdLabel";
  String _bookIdProp = "$entityLabel.$idLabel";

  BookEventRepository(ESStore<BookEvent> store) : super(store, bookEventDecoder);

  Future<void> deleteByAuthor(String authorId) {
    var authorIdQ = MatchQuery(_authorIdProp, authorId);
    logger.info("delete BookEvents by author: $authorId");
    return super
        .findDocuments(authorIdQ, PageRequest(1000, 0))
        .then((page) {
          logger.info("page of BookEvents to be deleted: ${page.toString()}");
          return page;
        })
        .then((page) => groupByEntityId(page))
        .then((map) => newest(map))
        .then((newestBooks) => Future.wait(newestBooks.map((book) => deleteBook(book.id))));
  }

  Map<String, List<BookEvent>> groupByEntityId(Page<BookEvent> page) {
    return groupBy(page.elements, (event) => event.entity.id);
  }

  List<Book> newest(Map<String, List<BookEvent>> data) {
    return data
        .map((key, value) {
          value.sort((a, b) => a.entity.createdUtc.compareTo(b.entity.createdUtc));
          return MapEntry(key, value[0].entity);
        })
        .values
        .toList();
  }

  Future<Page<BookEvent>> listEvents(ListEventsByBookRequest request) {
    var query = MatchQuery(_bookIdProp, request.bookId);
    var sorting = SortElement.asc(createdUtcLabel);
    return super.findDocuments(query, request.pageRequest, sorting: sorting);
  }

  Future<void> saveBook(Book book) {
    return this.save(BookEvent.create(book));
  }

  Future<void> updateBook(Book book) {
    return this.save(BookEvent.update(book));
  }

  Future<void> deleteBook(String bookId) {
    logger.info("delete BookEvent by id: $bookId");
    var idQuery = MatchQuery(_bookIdProp, bookId);
    var sorting = SortElement.desc(modifiedUtcLabel);

    return super
        .findDocuments(idQuery, PageRequest(1, 0), sorting: sorting)
        .then((page) => this.save(BookEvent.delete(page.elements[0].entity)));
  }
}
