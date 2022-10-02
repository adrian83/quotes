import 'dart:async';

import 'package:logging/logging.dart';

import 'package:quotesbe2/domain/common/model.dart';
import 'package:quotesbe2/domain/book/model/command.dart';
import 'package:quotesbe2/domain/book/model/entity.dart';
import 'package:quotesbe2/domain/book/model/query.dart';
import 'package:quotesbe2/domain/book/repository.dart';
import 'package:quotesbe2/domain/quote/repository.dart';

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
    _logger.info("save book: $book");
    await _bookRepository.save(book);
    _logger.info("store book event (create) for book: $book");
    await _bookEventRepository.storeSaveBookEvent(book);
    return book;
  }

  Future<Book> find(FindBookQuery query) async {
    _logger.info("find book by: $query");
    return await _bookRepository.find(query.bookId);
  }

  Future<Book> update(UpdateBookCommand command) async {
    var book = command.toBook();
    _logger.info("update book: $book");
    await _bookRepository.update(book);
    _logger.info("store book event (update) for book: $book");
    await _bookEventRepository.storeUpdateBookEvent(book);
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
