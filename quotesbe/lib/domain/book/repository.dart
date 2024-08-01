import 'dart:async';

import 'package:logging/logging.dart';

import 'package:quotesbe/domain/common/model.dart';
import 'package:quotesbe/domain/book/model/entity.dart';
import 'package:quotesbe/domain/book/model/query.dart';
import 'package:quotesbe/domain/common/repository.dart';
import 'package:quotesbe/storage/elasticsearch/store.dart';
import 'package:quotesbe/storage/elasticsearch/search.dart';
import 'package:quotes_common/domain/entity.dart';
import 'package:quotes_common/domain/book.dart';
import 'package:quotes_common/domain/page.dart';

Decoder<BookDocument> bookDecoder = (Map<String, dynamic> json) => BookDocument.fromJson(json);

class BookRepository extends Repository<BookDocument> {
  final Logger _logger = Logger('BookRepository');

  BookRepository(ESStore<BookDocument> store) : super(store, bookDecoder);

  Future<Page<BookDocument>> findAuthorBooks(ListBooksByAuthorQuery query) async {
    _logger.info("find author books by query: $query");
    var matchQuery = MatchQuery(fieldBookAuthorId, query.authorId);
    return await findDocuments(matchQuery, query.pageRequest, sorting: sortingByModifiedTimeDesc);
  }

  Future<Page<Book>> findBooks(SearchQuery query) async {
    _logger.info("find books by query: $query");
    var searchPhrase = query.searchPhrase ?? "";
    var wildcardQuery = WildcardQuery(fieldBookTitle, searchPhrase);
    return findDocuments(wildcardQuery, query.pageRequest, sorting: sortingByModifiedTimeDesc);
  }

  Future<void> deleteByAuthor(String authorId) async {
    _logger.info("delete books by author with id: $authorId");
    var query = JustQuery(MatchQuery(fieldBookAuthorId, authorId));
    await deleteDocuments(query);
    return;
  }
}

Decoder<BookEvent> bookEventDecoder = (Map<String, dynamic> json) => BookEvent.fromJson(json);

class BookEventRepository extends Repository<BookEvent> {
  final Logger _logger = Logger('BookEventRepository');

  final String _authorIdProp = "$entityLabel.$fieldBookAuthorId";
  final String _bookIdProp = "$entityLabel.$fieldEntityId";

  BookEventRepository(ESStore<BookEvent> store) : super(store, bookEventDecoder);

  Future<void> deleteByAuthor(String authorId) async {
    _logger.info("save book events (delete) for books created by author: $authorId");
    var matchQuery = MatchQuery(_authorIdProp, authorId);
    var books = await super.findAllDocuments(matchQuery);
    var newestBooks = newestEntities(books);
    Future.wait(newestBooks.map((book) => storeDeleteBookEvent(book)));
    return;
  }

  Future<void> storeDeleteBookEventByBookId(String bookId) async {
    _logger.info("save book event (delete) for book with id: $bookId");
    var matchQuery = MatchQuery(_bookIdProp, bookId);
    var page = await super.findDocuments(
      matchQuery,
      PageRequest.first(),
      sorting: sortingByModifiedTimeDesc,
    );
    await storeDeleteBookEvent(page.elements[0].entity);
    return;
  }

  Future<Page<BookEvent>> findBookEvents(ListEventsByBookQuery query) async {
    _logger.info("find book events by query: $query");
    var matchQuery = MatchQuery(_bookIdProp, query.bookId);
    return await super.findDocuments(
      matchQuery,
      query.pageRequest,
      sorting: sortingByCreatedTimeAsc,
    );
  }

  Future<void> storeSaveBookEvent(BookDocument book) async {
    _logger.info("save book event (save) for book: $book");
    await save(BookEvent.create(book));
    return;
  }

  Future<void> storeUpdateBookEvent(BookDocument book) async {
    _logger.info("save book event (update) for book: $book");
    await save(BookEvent.update(book));
    return;
  }

  Future<void> storeDeleteBookEvent(BookDocument book) async {
    _logger.info("save book event (delete) for book: $book");
    await save(BookEvent.delete(book));
    return;
  }
}
