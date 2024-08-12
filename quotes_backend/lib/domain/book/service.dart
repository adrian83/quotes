import 'dart:async';

import 'package:logging/logging.dart';

import 'package:quotes_backend/domain/common/model.dart';
import 'package:quotes_backend/domain/book/model/command.dart';
import 'package:quotes_backend/domain/book/model/entity.dart';
import 'package:quotes_backend/domain/book/model/query.dart';
import 'package:quotes_backend/domain/book/repository.dart';
import 'package:quotes_backend/domain/quote/repository.dart';
import 'package:quotes_common/domain/book.dart';
import 'package:quotes_common/domain/page.dart';

class BookService {
  final Logger _logger = Logger('BookService');

  final BookRepository _bookRepository;
  final BookEventRepository _bookEventRepository;
  final QuoteRepository _quoteRepository;
  final QuoteEventRepository _quoteEventRepository;

  BookService(
    this._bookRepository,
    this._bookEventRepository,
    this._quoteRepository,
    this._quoteEventRepository,
  );

  Future<Book> save(NewBookCommand command) async {
    var book = command.toBook();
    var bookDocument = BookDocument.fromModel(book);
    _logger.info("save book: $book");
    await _bookRepository.save(bookDocument);
    _logger.info("store book event (create) for book: $book");
    await _bookEventRepository.storeSaveBookEvent(bookDocument);
    return book;
  }

  Future<Book> find(FindBookQuery query) async {
    _logger.info("find book by: $query");
    return await _bookRepository.find(query.bookId);
  }

  Future<Book> update(UpdateBookCommand command) async {
    var book = command.toBook();
    var bookDocument = BookDocument.fromModel(book);
    _logger.info("update book: $book");
    await _bookRepository.update(bookDocument);
    _logger.info("store book event (update) for book: $book");
    await _bookEventRepository.storeUpdateBookEvent(bookDocument);
    return book;
  }

  Future<void> delete(DeleteBookCommand command) async {
    _logger.info("delete book with: $command");
    await _bookRepository.delete(command.bookId);
    _logger.info("store book event (delete) for book: $command");
    await _bookEventRepository.storeDeleteBookEventByBookId(command.bookId);
    await _quoteRepository.deleteByBook(command.bookId);
    await _quoteEventRepository.deleteByBook(command.bookId);
    return;
  }

  Future<void> deleteByAuthor(String authorId) async {
    _logger.info("delete books by author with id: $authorId");
    await _bookRepository.deleteByAuthor(authorId);
    _logger.info("store quote events (delete) for author with id: $authorId");
    await _bookEventRepository.deleteByAuthor(authorId);
    return;
  }

  Future<Page<Book>> findAuthorBooks(ListBooksByAuthorQuery query) async {
    _logger.info("find author books by query: $query");
    return await _bookRepository.findAuthorBooks(query);
  }

  Future<Page<Book>> findBooks(SearchQuery request) async {
    _logger.info("find books by query: $request");
    return await _bookRepository.findBooks(request);
  }

  Future<Page<BookEvent>> listEvents(ListEventsByBookQuery query) async {
    _logger.info("find book events by query: $query");
    return await _bookEventRepository.findBookEvents(query);
  }
}
