import 'dart:async';

import 'package:logging/logging.dart';

import 'model.dart';
import 'repository.dart';
import '../common/model.dart';
import '../common/exception.dart';
import '../quote/repository.dart';
import '../../common/function.dart';

class BookService {
  final Logger _logger = Logger('BookService');

  BookRepository _bookRepository;
  BookEventRepository _bookEventRepository;
  QuoteRepository _quoteRepository;
  QuoteEventRepository _quoteEventRepository;

  BookService(this._bookRepository, this._bookEventRepository, this._quoteRepository, this._quoteEventRepository);

  Future<Book> save(Book book) => Future.value(book)
      .then((_) => _logger.info("save book: $book"))
      .then((_) => _bookRepository.save(book))
      .then((_) => _logger.info("store book event (create) for book: $book"))
      .then((_) => pass(book, (b) => _bookEventRepository.storeSaveBookEvent(book)))
      .catchError(errorHandler);

  Future<Book> find(String bookId) => Future.value(bookId)
      .then((_) => _logger.info("find book by id: $bookId"))
      .then((_) => _bookRepository.find(bookId))
      .catchError(errorHandler);

  Future<Book> update(Book book) => Future.value(book)
      .then((_) => _logger.info("update book: $book"))
      .then((_) => _bookRepository.update(book))
      .then((_) => _logger.info("store book event (update) for book: $book"))
      .then((_) => pass(book, (b) => _bookEventRepository.storeUpdateBookEvent(book)))
      .catchError(errorHandler);

  Future<void> delete(String bookId) => Future.value(bookId)
      .then((_) => _logger.info("delete book with id: $bookId"))
      .then((_) => _bookRepository.delete(bookId))
      .then((_) => _logger.info("store book event (delete) for book with id: $bookId"))
      .then((_) => _bookEventRepository.storeDeleteBookEventByBookId(bookId))
      .then((_) => _logger.info("delete all quotes from book with id: $bookId"))
      .then((_) => _quoteRepository.deleteByBook(bookId))
      .then((_) => _logger.info("store quote events (delete) for book with id: $bookId"))
      .then((_) => _quoteEventRepository.deleteByBook(bookId))
      .catchError(errorHandler);

  Future<void> deleteByAuthor(String authorId) => Future.value(authorId)
      .then((_) => _logger.info("delete books by author with id: $authorId"))
      .then((_) => _bookRepository.deleteByAuthor(authorId))
      .then((_) => _logger.info("store quote events (delete) for author with id: $authorId"))
      .then((_) => _bookEventRepository.deleteByAuthor(authorId))
      .catchError(errorHandler);

  Future<Page<Book>> findAuthorBooks(ListBooksByAuthorRequest request) => Future.value(request)
      .then((_) => _logger.info("find author books by request: $request"))
      .then((value) => _bookRepository.findAuthorBooks(request))
      .catchError(errorHandler);

  Future<Page<Book>> findBooks(SearchEntityRequest request) => Future.value(request)
      .then((_) => _logger.info("find books by request: $request"))
      .then((_) => _bookRepository.findBooks(request))
      .catchError(errorHandler);

  Future<Page<BookEvent>> listEvents(ListEventsByBookRequest request) => Future.value(request)
      .then((_) => _logger.info("find book events by request: $request"))
      .then((_) => _bookEventRepository.findBookEvents(request))
      .catchError(errorHandler);
}
