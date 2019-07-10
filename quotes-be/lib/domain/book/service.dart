import 'dart:async';

import '../common/model.dart';
import '../quote/event.dart';
import '../quote/repository.dart';
import 'event.dart';
import 'model.dart';
import 'repository.dart';

class BookService {
  BookRepository _bookRepository;
  BookEventRepository _bookEventRepository;
  QuoteRepository _quoteRepository;
  QuoteEventRepository _quoteEventRepository;

  BookService(this._bookRepository, this._bookEventRepository, this._quoteRepository, this._quoteEventRepository);

  Future<Book> save(Book book) => _bookRepository.save(book.generateId()).then((_) => _bookEventRepository.save(book));

  Future<Book> find(String bookId) => _bookRepository.find(bookId);

  Future<Book> update(Book book) => _bookRepository.update(book).then((book) => _bookEventRepository.update(book));

  Future<void> delete(String bookId) => _bookRepository
      .delete(bookId)
      .then((_) => _bookEventRepository.delete(bookId))
      .then((_) => _quoteRepository.deleteByBook(bookId))
      .then((_) => _quoteEventRepository.deleteByBook(bookId));

  Future<void> deleteByAuthor(String authorId) =>
      _bookRepository.deleteByAuthor(authorId).then((_) => _bookEventRepository.deleteByAuthor(authorId));

  Future<Page<Book>> findAuthorBooks(String authorId, PageRequest request) =>
      _bookRepository.findAuthorBooks(authorId, request);

  Future<Page<Book>> findBooks(String searchPhrase, PageRequest request) =>
      _bookRepository.findBooks(searchPhrase, request);

  Future<Page<BookEvent>> listEvents(String authorId, String bookId, PageRequest request) =>
      _bookEventRepository.listEvents(authorId, bookId, request);
}
