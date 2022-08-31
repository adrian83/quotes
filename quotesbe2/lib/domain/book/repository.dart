import 'dart:async';

import 'package:logging/logging.dart';

import 'package:quotesbe2/domain/common/model.dart';
import 'package:quotesbe2/domain/book/model.dart';
import 'package:quotesbe2/domain/common/repository.dart';
import 'package:quotesbe2/storage/elasticsearch/store.dart';
import 'package:quotesbe2/storage/elasticsearch/search.dart';

Decoder<Book> bookDecoder = (Map<String, dynamic> json) => Book.fromJson(json);

class BookRepository extends Repository<Book> {
  final Logger _logger = Logger('BookRepository');

  BookRepository(ESStore<Book> store) : super(store, bookDecoder);

  Future<Page<Book>> findAuthorBooks(ListBooksByAuthorRequest request) =>
      Future.value(request)
          .then((_) => _logger.info("find author books by request: $request"))
          .then((_) => MatchQuery(bookAuthorIdLabel, request.authorId))
          .then((query) => findDocuments(query, request.pageRequest,
              sorting: SortElement.desc(modifiedUtcLabel)));

  Future<Page<Book>> findBooks(SearchQuery request) => Future.value(request)
      .then((_) => _logger.info("find books by request: $request"))
      .then((_) => WildcardQuery(bookTitleLabel, request.searchPhrase ?? ""))
      .then((query) => findDocuments(query, request.pageRequest,
          sorting: SortElement.desc(modifiedUtcLabel)));

  Future<void> deleteByAuthor(String authorId) => Future.value(authorId)
      .then((_) => _logger.info("delete books by author with id: $authorId"))
      .then((_) => JustQuery(MatchQuery(bookAuthorIdLabel, authorId)))
      .then((query) => deleteDocuments(query));
}

Decoder<BookEvent> bookEventDecoder =
    (Map<String, dynamic> json) => BookEvent.fromJson(json);

class BookEventRepository extends Repository<BookEvent> {
  final Logger _logger = Logger('BookEventRepository');

  String _authorIdProp = "$entityLabel.$bookAuthorIdLabel";
  String _bookIdProp = "$entityLabel.$idLabel";

  BookEventRepository(ESStore<BookEvent> store)
      : super(store, bookEventDecoder);

  Future<void> deleteByAuthor(String authorId) => Future.value(authorId)
      .then((_) => _logger.info(
          "save book events (delete) for books created by author with id: $authorId"))
      .then((_) => MatchQuery(_authorIdProp, authorId))
      .then((query) => super.findDocuments(query, PageRequest(1000, 0)))
      .then((page) => newestEntities(page))
      .then((newestBooks) =>
          Future.wait(newestBooks.map((book) => storeDeleteBookEvent(book))));

  Future<void> storeDeleteBookEventByBookId(String bookId) =>
      Future.value(bookId)
          .then((_) => _logger
              .info("save book event (delete) for book with id: $bookId"))
          .then((_) => MatchQuery(_bookIdProp, bookId))
          .then((query) => super.findDocuments(query, PageRequest.first(),
              sorting: SortElement.desc(modifiedUtcLabel)))
          .then((page) => storeDeleteBookEvent(page.elements[0].entity));

  Future<Page<BookEvent>> findBookEvents(ListEventsByBookRequest request) =>
      Future.value(request)
          .then((_) => _logger.info("find book events by request: $request"))
          .then((_) => MatchQuery(_bookIdProp, request.bookId))
          .then((query) => super.findDocuments(query, request.pageRequest,
              sorting: SortElement.asc(createdUtcLabel)));

  Future<void> storeSaveBookEvent(Book book) => Future.value(book)
      .then((_) => _logger.info("save book event (save) for book: $book"))
      .then((_) => save(BookEvent.create(book)));

  Future<void> storeUpdateBookEvent(Book book) => Future.value(book)
      .then((_) => _logger.info("save book event (update) for book: $book"))
      .then((_) => save(BookEvent.update(book)));

  Future<void> storeDeleteBookEvent(Book book) => Future.value(book)
      .then((_) => _logger.info("save book event (delete) for book: $book"))
      .then((_) => save(BookEvent.delete(book)));
}
